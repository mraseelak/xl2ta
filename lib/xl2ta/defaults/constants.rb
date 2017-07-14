# This moule contains all the constants needed for the tests
module Defaults
  module Constants
    module_function
    TIERS = %w(local int uat prod)

    def tier_local
      TIERS[0]
    end

    def tier_int
      TIERS[1]
    end

    def tier_uat
      TIERS[2]
    end

    def tier_prod
      TIERS[3]
    end

    def current_tier
      @tier
    end

    def valid_tier?(tier)
      status = TIERS.include? tier
      raise "Tier value #{tier} is not one of these: #{TIERS.join(',')}" unless status
      status
    end

    def set_tier(tier)
      @tier = tier if valid_tier? tier
    end

    # returns the port mapping based on ecosystem
    def local_port_mapping(ecosystem)
      return '10235' if ecosystem == 'treatment'
      return '10240' if ecosystem == 'patient'
      return '5000' if ecosystem == 'ion'
      return '8000'if ecosystem == 'dynamo'
    end

    def url_mapping(ecosystem)
      case @tier
        when TIERS[0] then
          "http://localhost:#{local_port_mapping(ecosystem)}"

        when TIERS[3] then
          "https://pedmatch.nci.nih.gov"

        else
          "https://pedmatch-#{@tier}.nci.nih.gov"
      end
    end

    def url_ta_api
      valid_tier? @tier
      ecosystem = 'treatment'
      "#{url_mapping(ecosystem)}/api/v1/treatment_arms"
    end

    def url_patient_api
      valid_tier? @tier
      ecosystem = 'patient'
      "#{url_mapping(ecosystem)}/api/v1/patients"
    end

    def url_ir_api
      valid_tier? @tier
      ecosystem = 'ion'
      "#{url_mapping(ecosystem)}/api/v1"
    end

    def s3_bucket
      valid_tier? @tier
      case @tier
        when TIERS[1] then
          'pedmatch-int'
        when TIERS[2] then
          'pedmatch-uat'
        when TIERS[3] then
          'pedmatch-prod'
        else
          'pedmatch-dev'
      end
    end

    def self.s3_bdd_ir
      'bdd_test_ion_reporter'
    end

    def dynamodb_url
      valid_tier? @tier
      case @tier
        when TIERS[0]
          "http://localhost:#{local_port_mapping('dynamo')}"
        when TIERS[3]
          "http://localhost:#{local_port_mapping('dynamo')}"  # to prevent accessing production
        else
          'https://dynamodb.us-east-1.amazonaws.com'
      end
    end

    def self.dynamodb_region
      'us-east-1'
    end

    def self.auth0_client_id
      valid_tier? @tier
      case @tier
        when TIERS[1] then
          ENV['INT_AUTH0_CLIENT_ID']
        when TIERS[2] then
          ENV['UAT_AUTH0_CLIENT_ID']
        when TIERS[3] then
          ENV['PROD_AUTH0_CLIENT_ID']
        else
          ENV['AUTH0_CLIENT_ID']
      end
    end

    def self.auth0_username
      valid_tier? @tier
      case @tier
        when TIERS[1] then
          ENV['INT_ADMIN_AUTH0_USERNAME']
        when TIERS[2] then
          ENV['UAT_ADMIN_AUTH0_USERNAME']
        when TIERS[3] then
          ENV['PROD_ADMIN_AUTH0_USERNAME']
        else
          ENV['ADMIN_AUTH0_USERNAME']
      end
    end

    def self.auth0_password
      valid_tier? @tier
      case @tier
        when TIERS[1] then
          ENV['INT_ADMIN_AUTH0_PASSWORD']
        when TIERS[2] then
          ENV['UAT_ADMIN_AUTH0_PASSWORD']
        when TIERS[3] then
          ENV['PROD_ADMIN_AUTH0_PASSWORD']
        else
          ENV['ADMIN_AUTH0_PASSWORD']
      end
    end

    def self.auth0_database
      valid_tier? @tier
      case @tier
        when TIERS[1] then
          ENV['INT_AUTH0_DATABASE']
        when TIERS[2] then
          ENV['UAT_AUTH0_DATABASE']
        when TIERS[3] then
          ENV['PROD_AUTH0_DATABASE']
        else
          ENV['AUTH0_DATABASE']
      end
    end

    def self.auth0_domain
      ENV['AUTH0_DOMAIN']
    end

  end
end
