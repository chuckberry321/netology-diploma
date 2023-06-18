
local p = import '../params.libsonnet';
local params = p.components.diploma-app_service;

[
    {
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "diploma-app",
  },
  "spec": {
    "type": "NodePort",
    "selector": {
      "app.kubernetes.io/name": "diploma-app"
    },
    "ports": [
      {
        "protocol": "TCP",
        "port": 80,
        "targetPort": 80,
        "nodePort": params.nodeport
      }
    ]
  }
}
]
