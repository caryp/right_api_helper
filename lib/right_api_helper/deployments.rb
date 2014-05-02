module RightApiHelper
  class Deployments
    def initialize(right_api_client)
      @client = right_api_client
    end

    # Return: MediaType : right_api_client deployment
    def find_or_create(name)
      log_info "Looking for deployment: '#{name}'..."
      deployment = @client.find_deployment_by_name(name)
      log_info "Deployment #{deployment.nil? ? "not found" : "found"}."
      unless deployment
        deployment = @client.create_deployment(name)
        log_info "Deployment created: '#{name}'"
      end
      deployment
    end

    private

    def log_info(message)
      puts message
    end

  end
end