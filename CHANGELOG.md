# Change Log

## 0.5.0
FEATURES:
- Added support for optimized_frequent_attach_enabled
- Added support for performance_plus_enabled
- Added support for upload_size_bytes
- Updated github actions
- Added release automation
- Added CHANGELOG.md
- Updated minimum terraform version to resolve this [issue](https://github.com/hashicorp/terraform/issues/32200)
- Updated minimum azurerm version to [3.73.0](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v3.73.0)

BUG FIXES:
- Added null value validations
- logical_sector_size, disk_iops_read_write, disk_mbps_read_write, disk_iops_read_only and disk_mbps_read_only can be set when storage_account_type is PremiumV2_LRS
- Updated go mod github.com/Azure/go-autorest/autorest/adal@latest
