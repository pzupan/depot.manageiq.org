require 'spec_helper'

describe Api::V1::UsersController do
  let!(:user) { create(:user) }

  let!(:redis_test) do
    create(:extension, name: 'redis_test', owner: user)
  end

  let!(:macand) do
    create(:extension, name: 'macand', owner: user)
  end

  let!(:zeromq) { create(:extension, name: 'zeromq') }
  let!(:apples) { create(:extension, name: 'apples') }
  let!(:postgres) { create(:extension, name: 'postgres') }
  let!(:ruby) { create(:extension, name: 'ruby') }
  let!(:berkshelf) { create(:tool, name: 'berkshelf', owner: user) }
  let!(:knife_supermarket) { create(:tool, name: 'knife_supermarket', owner: user) }
  let!(:dull_knife) { create(:tool, name: 'dull_knife') }
  let!(:xanadu) { create(:tool, name: 'xanadu') }

  describe '#show' do
    context 'when a user exists' do
      before do
        create(
          :account,
          provider: 'github',
          user: user,
          username: 'clive'
        )
        create(
          :account,
          provider: 'github',
          user: user,
          username: 'xanadu'
        )
        create(
          :extension_collaborator,
          resourceable: zeromq,
          user: user
        )
        create(
          :extension_collaborator,
          resourceable: apples,
          user: user
        )
        create(
          :extension_follower,
          extension: postgres,
          user: user
        )
        create(
          :extension_follower,
          extension: ruby,
          user: user
        )

        create(
          :tool_collaborator,
          resourceable: dull_knife,
          user: user
        )

        create(
          :tool_collaborator,
          resourceable: xanadu,
          user: user
        )
      end

      it 'responds with a 200' do
        get :show, user: 'clive', format: :json

        expect(response.status.to_i).to eql(200)
      end

      it 'sends the user to the view' do
        get :show, user: 'clive', format: :json

        expect(assigns[:user]).to eql(user)
      end

      it "sends the user's github accounts to the view" do
        get :show, user: 'clive', format: :json

        expect(assigns[:github_usernames]).to include('clive')
        expect(assigns[:github_usernames]).to include('xanadu')
      end

      it 'sorts the github accounts by username' do
        get :show, user: 'clive', format: :json

        expect(assigns[:github_usernames]).to include('clive',  'xanadu')
      end
      
      it 'sends the owned tools to the view' do
        get :show, user: 'clive', format: :json

        expect(assigns[:owned_tools]).to include(berkshelf)
        expect(assigns[:owned_tools]).to include(knife_supermarket)
      end

      it 'sorts the owned tools by name' do
        get :show, user: 'clive', format: :json

        expect(assigns[:owned_tools].to_a).to eql([berkshelf, knife_supermarket])
      end

      it 'sends the collaborated tools to the view' do
        get :show, user: 'clive', format: :json

        expect(assigns[:collaborated_tools]).to include(dull_knife)
        expect(assigns[:collaborated_tools]).to include(xanadu)
      end

      it 'sorts the collaborated tools by name' do
        get :show, user: 'clive', format: :json

        expect(assigns[:collaborated_tools].to_a).to eql([dull_knife, xanadu])
      end
    end

    context 'when a user does not exist' do
      it 'responds with a 404' do
        get :show, user: 'sushiqueen', format: :json

        expect(response.status.to_i).to eql(404)
      end
    end
  end
end
