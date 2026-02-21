locals {
    common_tags = {
        "Environment" = var.environment
        "Project"     = "test"        
        "Owner"       = "ehbc"
        "CostCenter"  = "engineering"
    }
}