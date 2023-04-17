provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "default" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

resource "kubernetes_namespace" "demo-namespace" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_service" "api" {
  metadata {
    name      = "demo-service"
    namespace = kubernetes_namespace.demo-namespace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.api.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "api" {
  metadata {
    name      = "demo-deployment"
    namespace = kubernetes_namespace.demo-namespace.metadata.0.name
    labels = {
      App = "SimpleNestApi"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "SimpleNestApi"
      }
    }

    template {
      metadata {
        labels = {
          App = "SimpleNestApi"
        }
      }

      spec {
        container {
          image = "shwaddell/simple-nest-api"
          name  = "simple-nest-api"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

output "lb_ip" {
  value = kubernetes_service.api.status.0.load_balancer.0.ingress.0.hostname
}
