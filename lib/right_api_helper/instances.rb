module RightApiHelper
  class Instances
    def initialize(right_api_client)
      @client = right_api_client
    end

    private

    def log_info(message)
      puts message
    end

  end
end