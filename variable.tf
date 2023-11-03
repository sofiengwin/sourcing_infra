variable "bucket_name" {
  type = string
  default = "sourcers"
}

variable "s3_key" {
  type = string
  default = "api_sourcer.zip"
}

variable "SUPABASE_URL" {
  type = string
  sensitive = true
  nullable = false
}
variable "SUPABASE_KEY" {
  type = string
  sensitive = true
  nullable = false
}

variable "X_RapidAPI_KEY" {
  type = string
  sensitive = true
  nullable = false
}