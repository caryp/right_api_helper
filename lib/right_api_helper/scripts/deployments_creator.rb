module RightApiHelper
  class DeploymentsCreator

    def run(argv)
      if argv.empty? or argv[0].empty?
        log_error "FATAL: you must supply path to json file"
        exit -1
      end
      filename = ""
      filename = argv[0] if argv[0]
      unless File.exists?(filename)
        log_error "FATAL: no such file: '#{filename}'"
        exit -2
      end

      @json = File.open(filename, "r") { |f| f.read }

    end



    private

    def log_error(message)
      puts message
    end

  end
end