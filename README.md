# coreos-cloudwatch-logs
This repository allows you to create a syslog container that forwards logs to AWS CloudWatch Logs

Forked from  [awslabs/ecs-cloudwatch-logs] (https://github.com/awslabs/ecs-cloudwatch-logs)

The repository provided by AWSLabs used some utilities specific to the AWS EC2 Container Service, and I've adjusted it here to work with [CoreOS] (https://coreos.com)  and derivitives such as [Deis] (https://deis.io/)

Prior to using this Image, you'll need to create an AWS user with these permissions

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:Create*",
            "logs:PutLogEvents"
            ],
          "Effect": "Allow",
          "Resource": "arn:aws:logs:*:*:*"
        }
      ]
    }


When running the container, provide the credentials through the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY variables like this:

    /usr/bin/docker run --name cloudwatchlogs -p 514:514 -e "AWS_ACCESS_KEY_ID=YOUR_AWS_KEY" -e "AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" roundsphere/cloudwatchlogs:stable

The prebuilt container is available on dockerhub at [roundsphere/cloudwatchlogs] (https://registry.hub.docker.com/u/roundsphere/cloudwatchlogs/).  The pre-built container will log to a Log Group named 'awslogs', and a stream named 'syslog'. If you'd like to change those, simply clone this repository, change those parameters in the awslogs.conf file, and rebuild the image.

If running on CoreOS, a sample service file is provided in cloudwatchlogs.service

Also, due to a bug introduced with the overlayfs in CoreOS 561 and later that prevents the AWS Log agent from detecting changes to the log file, you may need to format the host file system with btrfs using the workaround at [http://serverfault.com/questions/661454/tail-f-not-following-log-file-in-docker-container/704770#704770] (http://serverfault.com/questions/661454/tail-f-not-following-log-file-in-docker-container/704770#704770)
