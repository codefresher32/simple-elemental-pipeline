locals {
  dockerfile_md5 = filemd5("${path.root}/Dockerfile")
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.prefix}-batch-container-image"
}

resource "docker_image" "ecr_image" {
  name     = "${var.prefix}-ecr-image"
  platform = "linux/amd64"

  triggers = {
    dockerfile_md5 = local.dockerfile_md5
    all_files      = sha1(join("", [for f in fileset("${path.root}/scripts/", "*") : filesha1("${path.root}/scripts/${f}")]))
  }
  build {
    context      = abspath("${path.root}/")
    force_remove = true
    dockerfile   = "Dockerfile"
  }
}

resource "docker_tag" "ecr_tag" {
  source_image = docker_image.ecr_image.name
  target_image = "${aws_ecr_repository.ecr_repo.repository_url}:${local.dockerfile_md5}"
}

resource "docker_registry_image" "container_image" {
  name = docker_tag.ecr_tag.target_image
}
