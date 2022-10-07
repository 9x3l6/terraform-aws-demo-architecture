import os
import sys
import boto3

def start_stop_instances(event, context):
  region = os.environ['AWS_REGION']
  instances = [instance.strip() for instance in event['instances'].split(',') if instance]
  ec2 = boto3.client('ec2', region_name=region)
  if event['action'] == 'stop':
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.Client.stop_instances
    print('stopping your instances: ' + str(instances))
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
  elif event['action'] == 'start':
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.Client.start_instances
    print('starting your instances: ' + str(instances))
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
  else:
    print('unsupported action "%s" must be one of, start or stop; for instances: ' % event['action'] + str(instances))
