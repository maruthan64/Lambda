# variable "medtronic-tags" {
#   type = object({
#     environment-stage = string
#     cost-center = string
#     business-unit = string
#     business-contact = string
#     support-contact = string
#     wbs-code = string
#   })
#   description = "tags required by medtronic"
# }

# variable "project-info" {
#   type = object({
#     environment-name =  string
#     deployment-source = string
#     project-id = string
#   })
#   description = "tags for the project"
# }

variable "appshortname" { 
    type = string 
    description = "" 
}

variable "envtype" { 
    type = string 
    description = " lifecycle stage. e.g. dev, qa, stage" 
}

variable "apishortname" { 
    type = string 
    description = "" 
}

variable "region"{
   default = ""   
}