# resource "google_compute_instance" "tweet_producer_vm" {
#     name                      = "tweet-producer-vm"
#     machine_type              = var.vm_machine_type
#     tags                      = ["tweet-producer"]
#     allow_stopping_for_update = true

#     boot_disk {
#         initialize_params {
#             image = var.vm_image
#             size  = 30
#         }
#     }

#     network_interface {
#         network = var.network
#         access_config {
#         }
#     }
# }