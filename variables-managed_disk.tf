variable "managed_disk" {
  description = <<EOT
    (Optional) Manages managed disks.
    For more information on managed disks, such as sizing options and pricing, please check out https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview.

    CREATE OPTIONS

    name          - (Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created.

    storage_type  - (Optional) The type of storage to use for the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS.
                    Azure Ultra Disk Storage is only available in a region that support availability zones and can only enabled on selected VM series.
                    ZRS managed disk currently available only in selected regions. For more information please check https://docs.microsoft.com/en-gb/azure/virtual-machines/disks-redundancy#zone-redundant-storage-for-managed-disks.
                    For more information see the Azure Ultra Disk Storage product documentation https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal.

    create_option - (Optional) The method to use when creating the managed disk. Defaults to Empty.
                    Changing this forces a new resource to be created. Possible values include:

        Import    - Import a VHD file in to the managed disk (VHD specified with source_uri).
        Empty     - Create an empty managed disk.
        Copy      - Copy an existing managed disk or snapshot (specified with source_resource_id).
        FromImage - Copy a Platform Image (specified with image_reference_id)
        Restore   - Set by Azure Backup or Site Recovery on a restored disk (specified with source_resource_id).

    marketplace_reference_id  - (Optional) ID of an existing platform/marketplace disk image to copy when create_option is FromImage. 
                                This field cannot be specified if gallery_reference_id is specified.

    gallery_reference_id      - (Optional) ID of a Gallery Image Version to copy when create_option is FromImage. 
                                This field cannot be specified if marketplace_reference_id is specified.

    source_resource_id        - (Optional) The ID of an existing Managed Disk to copy create_option is Copy or the recovery point to restore when create_option is Restore.

    source_uri                - (Optional) URI to a valid VHD file to be used when create_option is Import.

    source_storage_id         - (Optional) The ID of the Storage Account where the source_uri is located. 
                                Required when create_option is set to Import. Changing this forces a new resource to be created.

    os_type                   - (Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows.

    hyper_v_generation        - (Optional) The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system. 
                                Possible values are V1 and V2. Defaults to V1.
                                Changing this forces a new resource to be created.
                                For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2.

    upload_size_bytes         - (Optional) Specifies the size of the managed disk to create in bytes. Required when create_option is Upload. The value must be equal to the source disk to be copied in bytes. 
                                Source disk size could be calculated with ls -l or wc -c. More information can be found at Copy a managed disk. Changing this forces a new resource to be created.
    

    DISK OPTIONS

    size_gb     - (Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes.
                  If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased.
                  Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.
                  Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    sector_size - (Optional) Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created.
                  Setting logical sector size is supported only with UltraSSD_LRS disks.

    tier        - (Optional) The disk performance tier to use.
                  This feature is currently supported only for premium SSDs.
                  This feature isn't currently supported with shared disks, eg. when max_shares is set.
                  Possible values are documented at https://docs.microsoft.com/en-us/azure/virtual-machines/disks-change-performance.
                  Changing this value is disruptive if the disk is attached to a Virtual Machine. The VM will be shut down and de-allocated as required by Azure to action the change.
                  Terraform will attempt to start the machine again after the update if it was in a running state when the apply was started.

    max_shares  - (Optional) The maximum number of VMs that can attach to the disk at the same time. Defaults to 1.
                  Value greater than one indicates a disk that can be mounted on multiple VMs at the same time.
                    Premium SSD maxShares limit: 
                      P15 and P20 disks: 2. 
                      P30,P40,P50 disks: 5. 
                      P60,P70,P80 disks: 10. 
                  For ultra disks the max_shares minimum value is 1 and the maximum is 5.

    zone        - (Optional) Specifies the Availability Zone in which this Managed Disk should be located. Changing this property forces a new resource to be created.

    optimized_frequent_attach_enabled - (Optional) Specifies whether this Managed Disk should be optimized for frequent disk attachments (where a disk is attached/detached more than 5 times in a day). Defaults to false.
                                        Note: Setting optimized_frequent_attach_enabled to true causes the disks to not align with the fault domain of the Virtual Machine, which can have operational implications.

    performance_plus_enabled          - (Optional) Specifies whether Performance Plus is enabled for this Managed Disk. Defaults to false. Changing this forces a new resource to be created.
                                        Note: performance_plus_enabled can only be set to true when using a Managed Disk with an Ultra SSD.
    
    ULTRA SSD OPTIONS

    iops_read_write - (Optional) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes.

    iops_read_only  - (Optional) The number of IOPS allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. One operation can transfer between 4k and 256k bytes.

    mbps_read_write - (Optional) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second.

    mbps_read_only  - (Optional) The bandwidth allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. MBps means millions of bytes per second.

    NETWORK OPTIONS

    public_access_enabled - (Optional) Whether it is allowed to access the disk via public network. Defaults to true.

    access_policy         - Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll. Defaults to AllowAll.

    access_id             - The ID of the disk access resource for using private endpoints on disks.
                            access_id is only supported when access_policy is set to AllowPrivate.

    ENCRYPTION OPTIONS

    encryption_set_id - (Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk.

    TIMEOUTS

    timeout_create - (Optional) Specify timeout for create action.

    timeout_update - (Optional) Specify timeout for update action.

    timeout_read   - (Optional) Specify timeout for read action.

    timeout_delete - (Optional) Specify timeout for delete action.

  EOT
  type = list(object({
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
  default = null
}

#Global Vars
#Timeouts
variable "managed_disk_timeout_create" {
  description = "Specify timeout for create action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "managed_disk_timeout_update" {
  description = "Specify timeout for update action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "managed_disk_timeout_read" {
  description = "Specify timeout for read action. Defaults to 5 minutes."
  type        = string
  default     = "5m"
}
variable "managed_disk_timeout_delete" {
  description = "Specify timeout for delete action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}

#Encryption
variable "managed_disk_encryption_set_id" {
  description = "(Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk."
  type        = string
  default     = null
}