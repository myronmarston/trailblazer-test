require "test_helper"

class HelperTest < Minitest::Spec
  module Song
    Result    = Struct.new(:input, :success) do
      def success?; self.success; end
    end
    Update = ->(*args) { Result.new( args, true ) }
    Create = ->(*args) { Result.new( args, false ) }
  end

  class Test < Minitest::Spec
    include Trailblazer::Test::Helper::Operation

    #:call
    it do
      result = call Song::Update, { title: "Shipwreck" }
    end
    #:call end

    it do
      call Song::Update, { a: 1 }, { b: 2}
    end

    it do
      model = factory( Song::Update, {} )
    end

    it do
      assert_raises Trailblazer::Test::OperationFailedError do
        #:factory
        model = factory( Song::Create, { title: "Shipwreck" } )["model"]
        #:factory end
      end
    end
  end

  it { assert_equal [{title: "Shipwreck"}], Test.new(:a).test_0001_anonymous.input }
  it { assert_equal [{:a=>1}, {:b=>2}], Test.new(:a).test_0002_anonymous.input }

  # returns result.
  it { assert_equal %{#<struct HelperTest::Song::Result input=[{}], success=true>}, Test.new(:a).test_0003_anonymous.inspect }
  # raises error
  it { assert_instance_of Trailblazer::Test::OperationFailedError, Test.new(:a).test_0004_anonymous }
end
