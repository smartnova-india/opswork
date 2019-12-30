#/bin/sh
export AWS_ACCESS_KEY_ID='AKIA3XEWG4D6QKEGBHNF'
export AWS_SECRET_ACCESS_KEY='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'
CHEF_REPO="/Users/rajesh/RajeshWork/Projects/AWS/smart-chef-repo"
STACK_ID="ab741a66-7d6e-4d29-8f90-e3b83a2ac6e9"
# INSTANCE_ID="3a8da223-fe9d-4602-a557-d0c19f50e265";
INSTANCE_ID="f91c1160-7b45-47e4-a9cc-7bc99a3ff933";
# STACK_ID="3a8da223-fe9d-4602-a557-d0c19f50e265"
cd $CHEF_REPO/cookbooks
berks package $CHEF_REPO/cookbooks.tar.gz
aws s3 cp --acl public-read $CHEF_REPO/cookbooks.tar.gz s3://opswork-recipe/cookbooks.tar.gz
aws opsworks create-deployment \
    --stack-id $STACK_ID \
    --command "{\"Name\":\"update_custom_cookbooks\"}" \
    --instance-ids "$INSTANCE_ID" \
    --region us-east-1
echo "Success"