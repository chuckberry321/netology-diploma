
local p = import '../params.libsonnet';
local params = p.components.diploma-app_deployment;

[
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "name": "diploma-app",
        "labels": {
        "app.kubernetes.io/name": "diploma-app"
        }
    },
    "spec": {
        "replicas": params.replicas,
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/name": "diploma-app"
        }
        },
        "template": {
        "metadata": {
            "labels": {
            "app.kubernetes.io/name": "diploma-app"
            }
        },
        "spec": {
            "containers": [
            {
                "name": "diploma-app",
                "image": params.rep + '/' + params.tag,
                "resources": {
                "requests": {
                    "memory": "24Mi",
                    "cpu": "32m"
                },
                "limits": {
                    "memory": "48Mi",
                    "cpu": "64m"
                }
                },
                "ports": [
                {
                    "containerPort": 80
                }
                ]
            }
            ]
        }
        }
    }
    }
]
