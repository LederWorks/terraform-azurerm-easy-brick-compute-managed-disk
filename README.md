<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-azurerm-easy-brick-compute-managed-disk
LederWorks Easy Compute Managed Disk Brick Module

This module were created by [LederWorks](https://lederworks.com) IaC enthusiasts.

## About This Module
This module implements the [managed disk](https://lederworks.com/docs/microsoft-azure/bricks/compute/#managed-disk) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
- Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3.4)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.73.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.73.0)

## Example

```hcl
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
  tags = local.tags

  managed_disk = [

    #################################
    #### Disk 001 - Full Example ####
    #################################
    {
      #Required
      name         = "managed-disk-001"
      storage_type = "Premium_LRS"

      #Create Options
      create_option            = ""
      marketplace_reference_id = ""
      gallery_reference_id     = ""
      source_resource_id       = ""
      source_uri               = ""
      source_storage_id        = ""
      os_type                  = ""
      hyper_v_generation       = ""

      #Disk Options
      size_gb     = 63
      sector_size = number
      tier        = ""
      max_shares  = number
      zone        = 3

      #Ultra SSD Options
      iops_read_write = ""
      iops_read_only  = ""
      mbps_read_write = ""
      mbps_read_only  = ""

      #Network Options
      public_access_enabled = bool
      access_policy         = ""
      access_id             = ""

      #Encryption
      encryption_set_id = ""

      #Timeouts
      timeout_create = ""
      timeout_update = ""
      timeout_read   = ""
      timeout_delete = ""


    },

    ##################
    #### Disk 002 ####
    ##################
    {
      name         = "managed-disk-002"
      storage_type = "Standard_LRS"
      size_gb      = 63
      zone         = 3
    }
  ]
}
output "managed_disk_list" {
  value = module.compute-managed-disk.managed_disk_list
}
```

## Resources

The following resources are used by this module:

- [azurerm_managed_disk.managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: (Required) Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: (Required) ID of the Subscription

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_managed_disk"></a> [managed\_disk](#input\_managed\_disk)

Description:     (Optional) Manages managed disks.  
    For more information on managed disks, such as sizing options and pricing, please check out https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview.

    CREATE OPTIONS

    name          - (Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created.

    storage\_type  - (Optional) The type of storage to use for the managed disk. Possible values are Standard\_LRS, StandardSSD\_ZRS, Premium\_LRS, PremiumV2\_LRS, Premium\_ZRS, StandardSSD\_LRS or UltraSSD\_LRS.  
                    Azure Ultra Disk Storage is only available in a region that support availability zones and can only enabled on selected VM series.  
                    ZRS managed disk currently available only in selected regions. For more information please check https://docs.microsoft.com/en-gb/azure/virtual-machines/disks-redundancy#zone-redundant-storage-for-managed-disks.  
                    For more information see the Azure Ultra Disk Storage product documentation https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal.

    create\_option - (Optional) The method to use when creating the managed disk. Defaults to Empty.  
                    Changing this forces a new resource to be created. Possible values include:

        Import    - Import a VHD file in to the managed disk (VHD specified with source\_uri).  
        Empty     - Create an empty managed disk.  
        Copy      - Copy an existing managed disk or snapshot (specified with source\_resource\_id).  
        FromImage - Copy a Platform Image (specified with image\_reference\_id)  
        Restore   - Set by Azure Backup or Site Recovery on a restored disk (specified with source\_resource\_id).

    marketplace\_reference\_id  - (Optional) ID of an existing platform/marketplace disk image to copy when create\_option is FromImage.   
                                This field cannot be specified if gallery\_reference\_id is specified.

    gallery\_reference\_id      - (Optional) ID of a Gallery Image Version to copy when create\_option is FromImage.   
                                This field cannot be specified if marketplace\_reference\_id is specified.

    source\_resource\_id        - (Optional) The ID of an existing Managed Disk to copy create\_option is Copy or the recovery point to restore when create\_option is Restore.

    source\_uri                - (Optional) URI to a valid VHD file to be used when create\_option is Import.

    source\_storage\_id         - (Optional) The ID of the Storage Account where the source\_uri is located.   
                                Required when create\_option is set to Import. Changing this forces a new resource to be created.

    os\_type                   - (Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows.

    hyper\_v\_generation        - (Optional) The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system.   
                                Possible values are V1 and V2. Defaults to V1.  
                                Changing this forces a new resource to be created.  
                                For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2.

    upload\_size\_bytes         - (Optional) Specifies the size of the managed disk to create in bytes. Required when create\_option is Upload. The value must be equal to the source disk to be copied in bytes.   
                                Source disk size could be calculated with ls -l or wc -c. More information can be found at Copy a managed disk. Changing this forces a new resource to be created.  

    DISK OPTIONS

    size\_gb     - (Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes.  
                  If create\_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased.  
                  Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.  
                  Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    sector\_size - (Optional) Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created.  
                  Setting logical sector size is supported only with UltraSSD\_LRS disks.

    tier        - (Optional) The disk performance tier to use.  
                  This feature is currently supported only for premium SSDs.  
                  This feature isn't currently supported with shared disks, eg. when max\_shares is set.  
                  Possible values are documented at https://docs.microsoft.com/en-us/azure/virtual-machines/disks-change-performance.  
                  Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.  
                  Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    max\_shares  - (Optional) The maximum number of VMs that can attach to the disk at the same time. Defaults to 1.  
                  Value greater than one indicates a disk that can be mounted on multiple VMs at the same time.  
                    Premium SSD maxShares limit:   
                      P15 and P20 disks: 2.   
                      P30,P40,P50 disks: 5.   
                      P60,P70,P80 disks: 10.   
                  For ultra disks the max\_shares minimum value is 1 and the maximum is 5.

    zone        - (Optional) Specifies the Availability Zone in which this Managed Disk should be located. Changing this property forces a new resource to be created.

    optimized\_frequent\_attach\_enabled - (Optional) Specifies whether this Managed Disk should be optimized for frequent disk attachments (where a disk is attached/detached more than 5 times in a day). Defaults to false.  
                                        Note: Setting optimized\_frequent\_attach\_enabled to true causes the disks to not align with the fault domain of the Virtual Machine, which can have operational implications.

    performance\_plus\_enabled          - (Optional) Specifies whether Performance Plus is enabled for this Managed Disk. Defaults to false. Changing this forces a new resource to be created.  
                                        Note: performance\_plus\_enabled can only be set to true when using a Managed Disk with an Ultra SSD.  

    ULTRA SSD OPTIONS

    iops\_read\_write - (Optional) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes.

    iops\_read\_only  - (Optional) The number of IOPS allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. One operation can transfer between 4k and 256k bytes.

    mbps\_read\_write - (Optional) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second.

    mbps\_read\_only  - (Optional) The bandwidth allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. MBps means millions of bytes per second.

    NETWORK OPTIONS

    public\_access\_enabled - (Optional) Whether it is allowed to access the disk via public network. Defaults to true.

    access\_policy         - Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll. Defaults to AllowAll.

    access\_id             - The ID of the disk access resource for using private endpoints on disks.  
                            access\_id is only supported when access\_policy is set to AllowPrivate.

    ENCRYPTION OPTIONS

    encryption\_set\_id - (Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk.

    TIMEOUTS

    timeout\_create - (Optional) Specify timeout for create action.

    timeout\_update - (Optional) Specify timeout for update action.

    timeout\_read   - (Optional) Specify timeout for read action.

    timeout\_delete - (Optional) Specify timeout for delete action.

Type:

```hcl
list(object({
    name         = string
    storage_type = optional(string, "Standard_LRS")
    #Create Options
    create_option                  = optional(string, "Empty")
    marketplace_reference_id       = optional(string)
    gallery_reference_id           = optional(string)
    source_resource_id             = optional(string)
    source_uri                     = optional(string)
    source_storage_id              = optional(string)
    os_type                        = optional(string)
    hyper_v_generation             = optional(string)
    managed_disk_upload_size_bytes = optional(number)
    #Disk Options
    size_gb                           = optional(number)
    sector_size                       = optional(number)
    tier                              = optional(string)
    max_shares                        = optional(number)
    zone                              = optional(number)
    optimized_frequent_attach_enabled = optional(bool, false)
    performance_plus_enabled          = optional(bool, false)
    #Ultra SSD Options
    iops_read_write = optional(string)
    iops_read_only  = optional(string)
    mbps_read_write = optional(string)
    mbps_read_only  = optional(string)
    #Network Options
    public_access_enabled = optional(bool, true)
    access_policy         = optional(string, "AllowAll")
    access_id             = optional(string)
    #Encryption
    encryption_set_id = optional(string)
    #Timeouts
    timeout_create = optional(string)
    timeout_update = optional(string)
    timeout_read   = optional(string)
    timeout_delete = optional(string)
  }))
```

Default: `null`

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

Description: BYO Tags, as a map(string)

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_managed_disk_list"></a> [managed\_disk\_list](#output\_managed\_disk\_list)

Description: Map of created disks with name and ID.

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License

```text
MIT License

Copyright (c) 2023 LederWorks

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