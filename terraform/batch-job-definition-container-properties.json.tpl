{
  "command": ${command},
  "environment": ${environment},
  "image": "${image}",
  "memory": ${memory},
  "vcpus": ${vcpus},
  "jobRoleArn": "${jobRoleArn}",
  "volumes": [
    {
      "host": {
        "sourcePath": "${efs_mount_point}"
      },
      "name": "efs"
    }
  ],
  "mountPoints": [
    {
      "sourceVolume": "efs",
      "containerPath": "${efs_mount_point}",
      "readOnly": false
    }
  ]
}
