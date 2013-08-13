require 'spec_helper'

describe Posty::API do
  include Rack::Test::Methods

  def app
    Posty::API
  end

  shared_examples "users" do
    describe "GET /api/v1/domains/test.de/users" do
      it "returns all users for the domain test.de" do
        get "/api/v1/domains/test.de/users"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    
    describe "POST /api/v1/domains/test.de/users name='test@test.de' password='tester'" do
      it "creates the user test@test.de" do
        post "/api/v1/domains/test.de/users", {"name" => "test", "password" => "tester", "quota" => 1000000}
        last_response.status.should == 201
        expect(JSON.parse(last_response.body)["virtual_user"]).to include("name" => "test")
      end
    end
    
    describe "PUT /api/v1/domains/test.de/users/test name='posty@test.de'" do
      it "changes the user name from test@test.de to posty@test.de" do
        put "/api/v1/domains/test.de/users/test", {"name" => "posty"}
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_user"]).to include("name" => "posty")
      end
    end
  
    describe "DELETE /api/v1/domains/test.de/users/posty" do
      it "delete the user posty@test.de" do
        delete "/api/v1/domains/test.de/users/posty"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_user"]).to include("name" => "posty")
      end
    end
  end
  
  shared_examples "domain_aliases" do
    describe "GET /api/v1/domains/test.de/aliases" do
      it "returns all domain aliases for the domain test.de" do
        get "/api/v1/domains/test.de/aliases"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    
    describe "POST /api/v1/domains/test.de/aliases name='tester.de'" do
      it "creates the domain alias tester.de" do
        post "/api/v1/domains/test.de/aliases", {"name" => "tester.de"}
        last_response.status.should == 201
        expect(JSON.parse(last_response.body)["virtual_domain_alias"]).to include("name" => "tester.de")
      end
    end
    
    describe "PUT /api/v1/domains/test.de/aliases/tester.de name='tester2.de'" do
      it "changes the domain alias name from tester.de to tester2.de" do
        put "/api/v1/domains/test.de/aliases/tester.de", {"name" => "tester2.de"}
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_domain_alias"]).to include("name" => "tester2.de")
      end
    end
  
    describe "DELETE /api/v1/domains/test.de/aliases/tester2.de" do
      it "delete the domain alias tester2.de" do
        delete "/api/v1/domains/test.de/aliases/tester2.de"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_domain_alias"]).to include("name" => "tester2.de")
      end
    end
  end

  shared_examples "user_aliases" do
    describe "POST /api/v1/domains/test.de/users name='destination@test.de' password='tester' quota=10000" do
      it "creates the user destination@test.de" do
        post "/api/v1/domains/test.de/users", {"name" => "destination", "password" => "tester", "quota" => 10000}
        last_response.status.should == 201
        expect(JSON.parse(last_response.body)["virtual_user"]).to include("name" => "destination")
      end
    end

    describe "GET /api/v1/domains/test.de/users/destination/aliases" do
      it "returns all aliases for the user destination@test.de" do
        get "/api/v1/domains/test.de/users/destination/aliases"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    
    describe "POST /api/v1/domains/test.de/users/destination/aliases name='newalias'" do
      it "creates the user alias newalias@test.de" do
        post "/api/v1/domains/test.de/users/destination/aliases", {"name" => "newalias"}
        last_response.status.should == 201
        expect(JSON.parse(last_response.body)["virtual_user_alias"]).to include("name" => "newalias")
      end
    end
    
    describe "PUT /api/v1/domains/test.de/users/destination/aliases/newalias name='newalias'" do
      it "changes the user alias name from newalias@test.de to newalias2@test.de" do
        put "/api/v1/domains/test.de/users/destination/aliases/newalias", {"name" => "newalias2"}
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_user_alias"]).to include("name" => "newalias2")
      end
    end
  
    describe "DELETE /api/v1/domains/test.de/users/destination/aliases/newalias2" do
      it "delete the user alias newalias2@test.de" do
        delete "/api/v1/domains/test.de/users/destination/aliases/newalias2"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_user_alias"]).to include("name" => "newalias2")
      end
    end
  end

  describe Posty::API do
    describe "GET /api/v1/domains" do
      it "returns all domains" do
        get "/api/v1/domains"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
  
    describe "POST /api/v1/domains name='test.de'" do
      it "creates the domain test.de" do
        post "/api/v1/domains", {"name" => "test.de"}
        last_response.status.should == 201
        expect(JSON.parse(last_response.body)["virtual_domain"]).to include("name" => "test.de")
      end
    end
    
    include_examples "users"
    include_examples "domain_aliases"
    include_examples "user_aliases"

    describe "POST /api/v1/domains name='test.de'" do
      it "creates the domain test.de" do
        post "/api/v1/domains", {"name" => "test.de"}
        last_response.status.should == 400
        expect(JSON.parse(last_response.body)["error"]).to include("name" => ["has already been taken"])
      end
    end
        
    describe "PUT /api/v1/domains/test.de name='posty-soft.de'" do
      it "changes the domain name from test.de to posty-soft.de" do
        put "/api/v1/domains/test.de", {"name" => "posty-soft.de"}
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_domain"]).to include("name" => "posty-soft.de")
      end
    end
  
    describe "DELETE /api/v1/domains/posty-soft.de" do
      it "delete the domain posty-soft.de" do
        delete "/api/v1/domains/posty-soft.de"
        last_response.status.should == 200
        expect(JSON.parse(last_response.body)["virtual_domain"]).to include("name" => "posty-soft.de")
      end
    end
  end
end