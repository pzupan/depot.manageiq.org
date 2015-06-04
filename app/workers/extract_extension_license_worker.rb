class ExtractExtensionLicenseWorker
  include Sidekiq::Worker

  def perform(extension_id)
    @extension = Extension.find(extension_id)

    @repo = octokit.repo(@extension.github_repo, accept: "application/vnd.github.drax-preview+json")

    if @repo[:license]
      license = octokit.license(@repo[:license][:key], accept: "application/vnd.github.drax-preview+json")

      @extension.update_attributes(
        license_name: license[:name],
        license_text: license[:body]
      )
    end
  end

  private

  def octokit
    @octokit ||= Rails.configuration.octokit
  end
end
