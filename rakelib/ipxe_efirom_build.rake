namespace :ipxe do
  namespace :efirom do
    task :build do
      require_relative '../lib/qemu-contrib/ipxe'

      binary_dir       = 'bin-x86_64-efi'
      binary_file      = 'virtio-net.efirom'
      binary_dest      = './var/lib/libvirt/boot'
      chain_script_src = 'view/ipxe/embedded.ipxe.erb'

      ipxe = ::IPXE.new()
      ipxe.build(
        binary_dir,
        binary_file,
        binary_dest,
        chain_script_src
      )
    end # task :build
  end # namespace :efirom
end # namespace :ipxe
