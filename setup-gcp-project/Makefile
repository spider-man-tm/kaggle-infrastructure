# Default values for variables if not provided
GCP_PROJECT_ID ?= none
BILLING_ACCOUNT_ID ?= none
KAGGLE_KEY ?= none
COMPETITION_NAME ?= none
TF_STATE_BUCKET_NAME ?= none
GCS_LOCATION ?= asia-northeast1

# Macro to check if a variable is set and not equal to "none"
define check_var
	@if [ -z "$($(1))" ] || [ "$($(1))" = "none" ]; then \
		echo "\033[31mError: $(1) is not set or is empty.\033[0m"; \
		exit 1; \
	fi
endef


.PHONY: setup-gcp-project gcp-project-create service-account* gce* secretmanager*
setup-gcp-project:
	$(call check_var,GCP_PROJECT_ID)
	$(call check_var,BILLING_ACCOUNT_ID)
	$(call check_var,KAGGLE_KEY)
	$(call check_var,TF_STATE_BUCKET_NAME)
	make gcp-project-create
	make link-billing-account
	make iam/enable
	make gce/enable
	make gcs/enable
	make secretmanager/enable
	make resourcemanager/enable
	make service-account/create
	make service-account/role
	make service-account/save-local
	make add-iam-policy-binding
	make secretmanager/upload
	make bucket/create
	make bucket/versioning
	make bucket/iam-policy-binding

# Create a new Google Cloud project
gcp-project-create:
	gcloud projects create ${GCP_PROJECT_ID} --name=${GCP_PROJECT_ID}

# Link billing account to the newly created project
link-billing-account:
	gcloud beta billing projects link ${GCP_PROJECT_ID} --billing-account=${BILLING_ACCOUNT_ID}

iam/enable:
	gcloud services enable iam.googleapis.com --project=${GCP_PROJECT_ID}

gce/enable:
	gcloud services enable compute.googleapis.com --project=${GCP_PROJECT_ID}

gcs/enable:
	gcloud services enable storage.googleapis.com --project=${GCP_PROJECT_ID}

secretmanager/enable:
	gcloud services enable secretmanager.googleapis.com --project=${GCP_PROJECT_ID}

resourcemanager/enable:
	gcloud services enable cloudresourcemanager.googleapis.com --project=${GCP_PROJECT_ID}

# Create a service account named "terraform"
service-account/create:
	gcloud iam service-accounts create terraform \
	--display-name="terraform" \
	--project=${GCP_PROJECT_ID}

	n=0; until gcloud iam service-accounts describe \
	    terraform@$(GCP_PROJECT_ID).iam.gserviceaccount.com \
	    --project=$(GCP_PROJECT_ID) >/dev/null 2>&1; do \
	      echo "  waiting for SA propagation..."; \
	      sleep 5; n=$$((n+1)); [ $$n -lt 6 ] || { echo "SA propagation timeout"; exit 1; }; \
	done

# Assign roles to the terraform service account
service-account/role:
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	--member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	--role=roles/editor
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	--member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	--role=roles/secretmanager.secretAccessor
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	  --member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	  --role=roles/iam.workloadIdentityPoolAdmin
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	  --member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	  --role=roles/iam.serviceAccountAdmin

# Generate a service account key and save it for local Terraform use
service-account/save-local:
	mkdir -p ../terraform/credential
	gcloud iam service-accounts keys create ../terraform/credential/terraform-key.json \
	--iam-account=terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com

# Add project-level IAM admin role to the terraform service account
add-iam-policy-binding:
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
		--member="serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
		--role="roles/resourcemanager.projectIamAdmin"

# Manage Kaggle key in Secret Manager
secretmanager/upload:
	if gcloud secrets describe kaggle-key --project=${GCP_PROJECT_ID} > /dev/null 2>&1; then \
		gcloud secrets delete kaggle-key --project=${GCP_PROJECT_ID} --quiet; \
	fi
	gcloud secrets create kaggle-key --replication-policy=automatic --project=${GCP_PROJECT_ID}
	# Upload the Kaggle key data from the KAGGLE_KEY environment variable
	printf "%s" "${KAGGLE_KEY}" | gcloud secrets versions add kaggle-key --data-file=- --project=${GCP_PROJECT_ID}

# Create a GCS bucket for Terraform state
bucket/create:
	@if gsutil ls -b gs://$(TF_STATE_BUCKET_NAME) >/dev/null 2>&1; then \
		echo "Bucket gs://$(TF_STATE_BUCKET_NAME) already exists."; \
	else \
		gcloud storage buckets create gs://$(TF_STATE_BUCKET_NAME) \
			--project=$(GCP_PROJECT_ID) \
			--location=$(GCS_LOCATION); \
	fi

bucket/versioning:
	gsutil versioning set on gs://$(TF_STATE_BUCKET_NAME)

# Authorize the terraform service account to access the GCS bucket
bucket/iam-policy-binding:
	gcloud storage buckets add-iam-policy-binding gs://$(TF_STATE_BUCKET_NAME) \
		--member=serviceAccount:terraform@$(GCP_PROJECT_ID).iam.gserviceaccount.com \
		--role=roles/storage.objectAdmin
