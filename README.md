<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-azurerm-easy-brick-compute-managed-disk
LederWorks Easy Compute Managed Disk Brick Module

## Authors
  - [Bence Bánó](mailto:bence.bano@lederworks.com)

## About This Module
This module implements the [SECTION](https://lederworks.com/docs/microsoft-azure/bricks/compute/#section) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
    - Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Disclaimer / Known Issues
- Disclaimer
- Known Issues

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.24.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.24.0)

## Example

```hcl
### Example

#Resource Group
resource "azurerm_resource_group" "compute-managed-disk" {
  name     = "compute-managed-disk"
  location = "East US 2"
  tags     = local.tags
}

#Managed Disk Module
module "compute-managed-disk" {
  source  = "LederWorks/easy-brick-compute-managed-disk/azurerm"
  version = "X.X.X"

  # Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  # Resource Group
  resource_group_object = azurerm_resource_group.compute-managed-disk

  # Tags
  tags = data.terraform_remote_state.va2_infrastructure.outputs.terratest-tags

  managed_disk = [

    #################################
    #### Disk 001 - Full Example ####
    #################################
    {
      #Required
      managed_disk_name         = "managed-disk-001"
      managed_disk_storage_type = "Premium_LRS"

      #Create Options
      managed_disk_create_option            = ""
      managed_disk_marketplace_reference_id = ""
      managed_disk_gallery_reference_id     = ""
      managed_disk_source_resource_id       = ""
      managed_disk_source_uri               = ""
      managed_disk_source_storage_id        = ""
      managed_disk_os_type                  = ""
      managed_disk_hyper_v_generation       = ""

      #Disk Options
      managed_disk_size_gb     = 63
      managed_disk_sector_size = number
      managed_disk_tier        = ""
      managed_disk_max_shares  = number
      managed_disk_zone        = 3

      #Ultra SSD Options
      managed_disk_iops_read_write = ""
      managed_disk_iops_read_only  = ""
      managed_disk_mbps_read_write = ""
      managed_disk_mbps_read_only  = ""

      #Network Options
      managed_disk_public_access_enabled = bool
      managed_disk_access_policy         = ""
      managed_disk_access_id             = ""

      #Encryption
      managed_disk_encryption_set_id = ""

      #Timeouts
      managed_disk_timeout_create = ""
      managed_disk_timeout_update = ""
      managed_disk_timeout_read   = ""
      managed_disk_timeout_delete = ""


    },

    ##################
    #### Disk 002 ####
    ##################
    {
      managed_disk_name         = "managed-disk-002"
      managed_disk_storage_type = "Standard_LRS"
      managed_disk_size_gb      = 63
      managed_disk_zone         = 3
    }
  ]
}



#Outputs
#auth
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

#rgrp
output "resource_group_name" {
  value = azurerm_resource_group.compute-managed-disk.name
}

#disks
output "managed_disk_list" {
  value = module.compute-managed-disk.managed_disk_list
}
```

## Resources

The following resources are used by this module:

- [azurerm_managed_disk.managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_managed_disk"></a> [managed\_disk](#input\_managed\_disk)

Description:     (Required) Manages managed disks.  
    For more information on managed disks, such as sizing options and pricing, please check out https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview.

    REQUIRED

    `managed_disk_name` - (Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created.

    `managed_disk_storage_type` - (Required) The type of storage to use for the managed disk. Possible values are `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `PremiumV2_LRS`, `Premium_ZRS`, `StandardSSD_LRS` or `UltraSSD_LRS`.  
                                  Azure Ultra Disk Storage is only available in a region that support availability zones and can only enabled on selected VM series.  
                                  ZRS managed disk currently available only in selected regions. For more information please check https://docs.microsoft.com/en-gb/azure/virtual-machines/disks-redundancy#zone-redundant-storage-for-managed-disks.  
                                  For more information see the Azure Ultra Disk Storage product documentation https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal.

    CREATE OPTIONS

    `managed_disk_create_option` - (Optional) The method to use when creating the managed disk. Defaults to Empty.  
                                   Changing this forces a new resource to be created. Possible values include:

        Import    - Import a VHD file in to the managed disk (VHD specified with source\_uri).  
        Empty     - Create an empty managed disk.  
        Copy      - Copy an existing managed disk or snapshot (specified with source\_resource\_id).  
        FromImage - Copy a Platform Image (specified with image\_reference\_id)  
        Restore   - Set by Azure Backup or Site Recovery on a restored disk (specified with source\_resource\_id).

    `managed_disk_marketplace_reference_id` - (Optional) ID of an existing platform/marketplace disk image to copy when `managed_disk_create_option` is FromImage.   
                                              This field cannot be specified if `managed_disk_gallery_reference_id` is specified.

    `managed_disk_gallery_reference_id` - (Optional) ID of a Gallery Image Version to copy when `managed_disk_create_option` is FromImage.   
                                          This field cannot be specified if `managed_disk_marketplace_reference_id` is specified.

    `managed_disk_source_resource_id` - (Optional) The ID of an existing Managed Disk to copy `managed_disk_create_option` is Copy or the recovery point to restore when `managed_disk_create_option` is Restore.

    `managed_disk_source_uri` - (Optional) URI to a valid VHD file to be used when `managed_disk_create_option` is Import.

    `managed_disk_source_storage_id` - (Optional) The ID of the Storage Account where the `managed_disk_source_uri` is located.   
                                       Required when `managed_disk_create_option` is set to Import. Changing this forces a new resource to be created.

    `managed_disk_os_type` - (Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows.

    `managed_disk_hyper_v_generation` - (Optional) The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system.   
                                        Possible values are V1 and V2. Defaults to V1.  
                                        Changing this forces a new resource to be created.  
                                        For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2.

    DISK OPTIONS

    `managed_disk_size_gb` - (Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes.  
                             If `managed_disk_create_option` is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased.  
                             Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.  
                             Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    `managed_disk_sector_size` - (Optional) Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created.  
                                Setting logical sector size is supported only with `UltraSSD_LRS` disks.

    `managed_disk_tier` - (Optional) The disk performance tier to use.  
                          This feature is currently supported only for premium SSDs.  
                          This feature isn't currently supported with shared disks, eg. when `managed_disk_max_shares` is set.  
                          Possible values are documented at https://docs.microsoft.com/en-us/azure/virtual-machines/disks-change-performance.  
                          Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.  
                          Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    `managed_disk_max_shares` - (Optional) The maximum number of VMs that can attach to the disk at the same time. Defaults to 1.  
                                Value greater than one indicates a disk that can be mounted on multiple VMs at the same time.  
                                Premium SSD maxShares limit:   
                                    P15 and P20 disks: 2.   
                                    P30,P40,P50 disks: 5.   
                                    P60,P70,P80 disks: 10.   
                                For ultra disks the max\_shares minimum value is 1 and the maximum is 5.

    `managed_disk_zone` - (Optional) Specifies the Availability Zone in which this Managed Disk should be located. Changing this property forces a new resource to be created.

    ULTRA SSD OPTIONS

    `managed_disk_iops_read_write` - (Optional) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes.

    `managed_disk_iops_read_only` - (Optional) The number of IOPS allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. One operation can transfer between 4k and 256k bytes.

    `managed_disk_mbps_read_write` - (Optional) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second.

    `managed_disk_mbps_read_only` - (Optional) The bandwidth allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. MBps means millions of bytes per second.

    NETWORK OPTIONS

    `managed_disk_public_access_enabled` - (Optional) Whether it is allowed to access the disk via public network. Defaults to true.

    `managed_disk_access_policy` - Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll. Defaults to AllowAll.

    `managed_disk_access_id` - The ID of the disk access resource for using private endpoints on disks.
                               `managed_disk_access_id` is only supported when `managed_disk_access_policy` is set to AllowPrivate.

    ENCRYPTION OPTIONS

    `managed_disk_encryption_set_id` - (Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk.

    TIMEOUTS

    `managed_disk_timeout_create` - (Optional) Specify timeout for create action.

    `managed_disk_timeout_update` - (Optional) Specify timeout for update action.

    `managed_disk_timeout_read` - (Optional) Specify timeout for read action.

    `managed_disk_timeout_delete` - (Optional) Specify timeout for delete action.

Type:

```hcl
list(object({
    managed_disk_name         = string
    managed_disk_storage_type = string
    #Create Options
    managed_disk_create_option            = optional(string)
    managed_disk_marketplace_reference_id = optional(string)
    managed_disk_gallery_reference_id     = optional(string)
    managed_disk_source_resource_id       = optional(string)
    managed_disk_source_uri               = optional(string)
    managed_disk_source_storage_id        = optional(string)
    managed_disk_os_type                  = optional(string)
    managed_disk_hyper_v_generation       = optional(string)
    #Disk Options
    managed_disk_size_gb     = optional(number)
    managed_disk_sector_size = optional(number)
    managed_disk_tier        = optional(string)
    managed_disk_max_shares  = optional(number)
    managed_disk_zone        = optional(number)
    #Ultra SSD Options
    managed_disk_iops_read_write = optional(string)
    managed_disk_iops_read_only  = optional(string)
    managed_disk_mbps_read_write = optional(string)
    managed_disk_mbps_read_only  = optional(string)
    #Network Options
    managed_disk_public_access_enabled = optional(bool)
    managed_disk_access_policy         = optional(string)
    managed_disk_access_id             = optional(string)
    #Encryption
    managed_disk_encryption_set_id = optional(string)
    #Timeouts
    managed_disk_timeout_create = optional(string)
    managed_disk_timeout_update = optional(string)
    managed_disk_timeout_read   = optional(string)
    managed_disk_timeout_delete = optional(string)
  }))
```

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: ID of the Subscription

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_managed_disk_encryption_set_id"></a> [managed\_disk\_encryption\_set\_id](#input\_managed\_disk\_encryption\_set\_id)

Description: (Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk.

Type: `string`

Default: `null`

### <a name="input_managed_disk_timeout_create"></a> [managed\_disk\_timeout\_create](#input\_managed\_disk\_timeout\_create)

Description: Specify timeout for create action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_managed_disk_timeout_delete"></a> [managed\_disk\_timeout\_delete](#input\_managed\_disk\_timeout\_delete)

Description: Specify timeout for delete action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_managed_disk_timeout_read"></a> [managed\_disk\_timeout\_read](#input\_managed\_disk\_timeout\_read)

Description: Specify timeout for read action. Defaults to 5 minutes.

Type: `string`

Default: `"5m"`

### <a name="input_managed_disk_timeout_update"></a> [managed\_disk\_timeout\_update](#input\_managed\_disk\_timeout\_update)

Description: Specify timeout for update action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: BYO Tags, preferrable from a local on your side :D

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_managed_disk_list"></a> [managed\_disk\_list](#output\_managed\_disk\_list)

Description: n/a

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License & Authors

Author: Bence Bánó (@Ledermayer)

```text
MIT License

Copyright (c) 2022 LederWorks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
<!-- END_TF_DOCS -->