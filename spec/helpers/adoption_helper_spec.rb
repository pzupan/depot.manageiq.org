require 'spec_helper'

describe AdoptionHelper do
  before do
    fake_policy = double(:policy, :manage_adoption? => true)
    allow(helper).to receive(:policy) { fake_policy }
  end

  context 'Extensions' do
    it 'generates a link to enable adoption for a Extension' do
      extension = create(:extension, name: 'haha', up_for_adoption: false)
      link = helper.link_to_adoption(extension)
      expected_link = '<li><a data-method="patch" href="/extensions/haha?extension%5Bup_for_adoption%5D=true" rel="nofollow"><i class="fa fa-heart"></i> Put up for adoption</a></li>'
      expect(link).to eql(expected_link)
    end

    it 'generates a link to disable adoption for a Extension' do
      extension = create(:extension, name: 'haha', up_for_adoption: true)
      link = helper.link_to_adoption(extension)
      expected_link = '<li><a data-method="patch" href="/extensions/haha?extension%5Bup_for_adoption%5D=false" rel="nofollow"><i class="fa fa-heart"></i> Disable adoption</a></li>'
      expect(link).to eql(expected_link)
    end
  end
end
