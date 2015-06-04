require "spec_helper"

describe CreateExtension do
  let(:params) { { name: "asdf", description: "desc", github_url: "cvincent/test" } }
  let(:user) { double(:user, github_account: github_account) }
  let(:github_account) { double(:github_account, username: "some_user") }
  let(:github) { double(:github) }

  let(:extension) do
    double(:extension,
      valid?: true,
      save: true,
      github_repo: "cvincent/test",
      errors: errors
    )
  end

  let(:errors) { double(:errors) }

  subject { CreateExtension.new(params, user, github) }

  before do
    allow(Extension).to receive(:new) { extension }
    allow(github).to receive(:collaborator?).with("cvincent/test", "some_user") { true }
  end

  it "saves a valid extension, returning the extension" do
    expect(extension).to receive(:save)
    expect(subject.process!).to be(extension)
  end

  it "does not save an invalid extension, returning the extension" do
    allow(extension).to receive(:valid?) { false }
    expect(extension).not_to receive(:save)
    expect(subject.process!).to be(extension)
  end

  it "does not check the repo collaborators if the extension is invalid" do
    allow(extension).to receive(:valid?) { false }
    expect(github).not_to receive(:collaborator?)
    expect(subject.process!).to be(extension)
  end

  it "does not save and adds an error if the user is not a collaborator in the repo" do
    allow(github).to receive(:collaborator?).with("cvincent/test", "some_user") { false }
    expect(extension).not_to receive(:save)
    expect(errors).to receive(:[]=).with(:github_url, I18n.t("extension.github_url_format_error"))
    expect(subject.process!).to be(extension)
  end

  it "does not save and adds an error if the repo is invalid" do
    allow(github).to receive(:collaborator?).with("cvincent/test", "some_user").and_raise(ArgumentError)
    expect(extension).not_to receive(:save)
    expect(errors).to receive(:[]=).with(:github_url, I18n.t("extension.github_url_format_error"))
    expect(subject.process!).to be(extension)
  end
end
