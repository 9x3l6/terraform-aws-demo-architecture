import os
import sys
import boto3

def lambda_handler(event, context):
  region = os.environ['AWS_REGION']
  if type(event['instances']) == str:
    instances = [instance.strip() for instance in event['instances'].split(',') if instance]
  else:
    instances = [instance.strip() for instance in event['instances'] if instance]
  ec2 = boto3.client('ec2', region_name=region)
  if event['action'] == 'stop':
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
  elif event['action'] == 'start':
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
  else:
    print('unsupported action "%s" must be one of, start or stop; for instances: ' % event['action'] + str(instances))
