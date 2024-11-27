# Default values for variables if not provided
GCP_PROJECT_ID ?= none           # Google Cloud Project ID
BILLING_ACCOUNT_ID ?= none       # Billing Account ID for GCP project
KAGGLE_KEY ?= none               # Kaggle API key, for use in Secret Manager

# Macro to check if a variable is set and not equal to "none"
define check_var
	@if [ -z "$($(1))" ] || [ "$($(1))" = "none" ]; then \
		echo "\033[31mError: $(1) is not set or is empty.\033[0m"; \
		exit 1; \
	fi
endef

# PHONY target for setting up a GCP project environment
.PHONY: setup-gcp-project gcp-project-create service-account* gce* secretmanager*
setup-gcp-project:
	# Check if required variables are set, otherwise exit with an error
	$(call check_var,GCP_PROJECT_ID)
	$(call check_var,BILLING_ACCOUNT_ID)
	$(call check_var,KAGGLE_KEY)
	# Execute commands to create the project, link billing, configure accounts, and enable services
	make gcp-project-create
	make link-billing-account
	make service-account/create
	make service-account/role
	make service-account/save-local
	make gce/enable
	make secretmanager/enable
	make secretmanager/upload
	make iam/enable
	make resourcemanager/enable
	make add-iam-policy-binding

# Step 1: Create a new Google Cloud project
gcp-project-create:
	gcloud projects create ${GCP_PROJECT_ID} --name=${GCP_PROJECT_ID}

# Step 2: Link billing account to the newly created project
link-billing-account:
	gcloud beta billing projects link ${GCP_PROJECT_ID} --billing-account=${BILLING_ACCOUNT_ID}

# Step 3: Create a service account named "terraform"
service-account/create:
	gcloud iam service-accounts create terraform \
	--display-name="terraform" \
	--project=${GCP_PROJECT_ID}

# Step 4: Assign roles to the terraform service account
service-account/role:
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	--member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	--role=roles/editor
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
	--member=serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
	--role=roles/secretmanager.secretAccessor

# Step 5: Generate a service account key and save it for local Terraform use
service-account/save-local:
	mkdir -p ../terraform/credential
	gcloud iam service-accounts keys create ../terraform/credential/terraform-key.json \
	--iam-account=terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com

# Step 6: Enable Google Compute Engine API, required for compute resources
gce/enable:
	gcloud services enable compute.googleapis.com --project=${GCP_PROJECT_ID}

# Step 7: Enable Secret Manager API, required for storing and managing secrets
secretmanager/enable:
	gcloud services enable secretmanager.googleapis.com --project=${GCP_PROJECT_ID}

# Step 8: Manage Kaggle key in Secret Manager
secretmanager/upload:
	if gcloud secrets describe kaggle-key --project=${GCP_PROJECT_ID} > /dev/null 2>&1; then \
		gcloud secrets delete kaggle-key --project=${GCP_PROJECT_ID} --quiet; \
	fi
	gcloud secrets create kaggle-key --replication-policy=automatic --project=${GCP_PROJECT_ID}
	# Upload the Kaggle key data from the KAGGLE_KEY environment variable
	printf "%s" "${KAGGLE_KEY}" | gcloud secrets versions add kaggle-key --data-file=- --project=${GCP_PROJECT_ID}

# Step 9: Enable IAM API, required for managing identity and access control policies
iam/enable:
	gcloud services enable iam.googleapis.com --project=${GCP_PROJECT_ID}

# Step 10: Enable Cloud Resource Manager API, required for project and IAM policy management
resourcemanager/enable:
	gcloud services enable cloudresourcemanager.googleapis.com --project=${GCP_PROJECT_ID}

# Step 11: Add project-level IAM admin role to the terraform service account
add-iam-policy-binding:
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
		--member="serviceAccount:terraform@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
		--role="roles/resourcemanager.projectIamAdmin"
