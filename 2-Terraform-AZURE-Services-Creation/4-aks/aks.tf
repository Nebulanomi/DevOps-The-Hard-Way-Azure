resource "azurerm_kubernetes_cluster" "k8s" {
  name                      = "${var.name}aks"
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  dns_prefix                = "${var.name}dns"
  kubernetes_version        = var.kubernetes_version
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  node_resource_group       = "${var.name}-node-rg"
  automatic_upgrade_channel = "patch"
  local_account_disabled    = false

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name                   = "agentpool"
    node_count             = var.agent_count
    vm_size                = var.vm_size
    vnet_subnet_id         = data.azurerm_subnet.akssubnet.id
    type                   = "VirtualMachineScaleSets"
    orchestrator_version   = var.kubernetes_version
    auto_scaling_enabled   = true
    min_count              = 1
    max_count              = 5
    max_pods               = 110
    os_disk_size_gb        = 30
    zones                  = ["1", "2", "3"]
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = [var.aks_admins_group_object_id]
  }

  tags = var.tags

}