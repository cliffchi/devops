terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  
  credentials = file("natural-venture-307108-0877751904db.json")

  project = "natural-venture-307108"
  region  = "asia-east1"
  zone	  = "asia-east1-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}


resource "google_compute_instance" "vm_instance" {
  name		= "terraform-instance"
  machine_type	= "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "random_string" "bucket" {
  length  = 8
  special = false
  upper	  = false
}

resource "google_storage_bucket" "example_bucket" {
  name	   = "learn-gcp-${random_string.bucket.result}"
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
} 

resource "google_compute_instance" "anther_instance" {
  depends_on = [google_storage_bucket.example_bucket]

  name		= "terraform-instance-2"
  machine_type  = "f1-micro"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}


















