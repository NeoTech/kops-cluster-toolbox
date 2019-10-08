echo "NOTE: YOU WILL NEED AWS CREDENTIALS SET IN YOU ENV FOR THIS"
echo "-----------------------------------------------------------"

read -p 'Bucket name: ' BUCKET
read -p 'Region: ' REGION
aws s3api create-bucket --bucket $BUCKET --region $REGION --create-bucket-configuration LocationConstraint=$REGION
aws s3api put-bucket-versioning --bucket $BUCKET --versioning-configuration Status=Enabled
