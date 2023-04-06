variable "context" {
  description = "Provides standardized naming policy and attribute information for data source reference to define cloud resources for a Project."
  type        = object({
    region      = string # describe default region to create a resource from aws
    project     = string # project name is usally account's project name or platform name
    name_prefix = string # resource name prefix
    pri_domain  = string # private domain name (ex, tools.customer.co.kr)
    tags        = map(string)
  })
}
