#require_relative 'ipxe/class_mixin'
require_relative 'ipxe/instance_mixin'
require 'rake/file_utils'

class IPXE
  #extend  ::IPXE::ClassMixin
  include ::FileUtils
  include ::IPXE::InstanceMixin
end
