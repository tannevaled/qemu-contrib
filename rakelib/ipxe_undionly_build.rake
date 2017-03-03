namespace :ipxe do
  namespace :undionly do
    task :build do
      require_relative '../lib/qemu-contrib/ipxe'

      binary_dir       = 'bin'
      binary_file      = 'undionly.kpxe'
      binary_dest      = './var/www/html/pxeboot/'
      chain_script_src = 'view/ipxe/embedded.ipxe.erb'

      ipxe = ::IPXE.new()
      ipxe.build(
        binary_dir,
        binary_file,
        binary_dest,
        chain_script_src
      )
    end # task :build
  end # namespace :undionly
end # namespace :ipxe
