require 'awesome_print'


class IPXE
  module InstanceMixin
    def build(
        binary_dir,
        binary_file,
        binary_dest,
        chain_script_src
      )

      binary = "#{binary_dir}/#{binary_file}"
      chain_script = 'chain_script.ipxe'
      ap @ipxe_dir
      sh 'pwd'
      sh 'ls -ltr'

      git_commit = 'master'
      sh 'git clone https://git.ipxe.org/ipxe.git' unless Dir.exist?('ipxe')
      Dir.chdir('ipxe') do
        sh "git checkout #{git_commit}"
      end
      Dir.chdir('ipxe/src') do
        puts Dir.pwd
        input = IO.read(File.expand_path("../../#{chain_script_src}"))
        context = { git_commit:'666' }
        chain_script_content = ::Erubis::Eruby.new(input).evaluate(context)
        IO.write(chain_script,chain_script_content, mode:File::WRONLY|File::CREAT)

        sh "make clean && make #{binary} EMBED=#{chain_script} && cp #{binary} #{binary_dest}"

      end
    end
  end
end
