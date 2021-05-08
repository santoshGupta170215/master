#!/bin/bash

#Shell Script containing the helm commands to deploy the data-agreement service

set -e

echo "Connecting to cluster"
gcloud beta container clusters get-credentials dmp-cluster-$ENVIRONMENT --zone $GOOGLE_PROJECT_REGION --project $GOOGLE_PROJECT_ID

echo "Deploying Data Agreement service on $ENVIRONMENT environment"
helm upgrade --install\
             --set label.ssr=$SSR\
             --set label.project_id="marketplace-$ENVIRONMENT"\
             --set label.cluster_name="dmp-cluster-$ENVIRONMENT"\
             --set image.repository=gcr.io/$CONTAINER_REGISTRY_NAME/$SERVICE_NAME\
             --set image.tag=:$DOCKER_IMAGE_TAG\
             --set env.token_auth="$TOKEN_AUTH"\
             --set env.mrktplace_proj_id="$MRKTPLACE_PROJ_ID"\
             --set env.mrktplace_serv_id="$MRKTPLACE_SERV_ID"\
             --set env.ccm_context_url="$CCM_CONTEXT_URL"\
             --set env.ccm_user_role_url="$CCM_USER_ROLE_URL"\
             --set env.env_tag=$ENVIRONMENT\
             --set env.kms_key_name=$KMS_KEY_NAME\
             --set env.env_url="$ENV_URL"\
             --set env.sauth_certificates_refresh_url="$SAUTH_CERTIFICATES_REFRESH_URL"\
             --set env.sauth_audience="$SAUTH_AUDIENCE"\
             --set env.service_token="$SERVICE_TOKEN"\
             --set env.storage_records_url="$STORAGE_RECORDS_URL"\
             --set env.ntm_message_uri="$NTM_MESSAGE_URI"\
             --set env.ccm_role_uri="$CCM_ROLE_URI"\
             --set env.userlist_uri_users="$USERLIST_URI_USERS"\
             --set env.email_notifications="$EMAIL_NOTIFICATIONS"\
             --set env.jwt_audiences="$JWT_AUDIENCES"\
             --set env.role_appcode="$ROLE_APPCODE"\
             --set env.app_key="$APP_KEY"\
             --set env.build_id="$BUILD_BUILDID"\
             --set env.build_commit_id="$BUILD_SOURCEVERSION"\
             --wait\
             --atomic data-agreement _data-agreement-build-new/dmp-data-agreement/data-agreement/\
             --namespace=marketplace-$ENVIRONMENT