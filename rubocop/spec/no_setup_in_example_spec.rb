# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_setup_in_example"

RSpec.describe CustomCops::NoSetupInExample do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new("CustomCops/NoSetupInExample" => {})
  end

  subject(:cop) { described_class.new(config) }

  context "instance_double inside an example block" do
    it "registers an offense for instance_double in `it`" do
      expect_offense(<<~RUBY)
        it "does something" do
          dbl = instance_double(User)
                ^^^^^^^^^^^^^^^^^^^^^ Avoid `instance_double` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end

    it "registers an offense for instance_double in `specify`" do
      expect_offense(<<~RUBY)
        specify do
          dbl = instance_double(User)
                ^^^^^^^^^^^^^^^^^^^^^ Avoid `instance_double` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end

    it "registers an offense for instance_double in `example`" do
      expect_offense(<<~RUBY)
        example "something" do
          dbl = instance_double(User)
                ^^^^^^^^^^^^^^^^^^^^^ Avoid `instance_double` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end
  end

  context "factory calls inside an example block" do
    it "registers an offense for create(:factory)" do
      expect_offense(<<~RUBY)
        it "does something" do
          user = create(:user)
                 ^^^^^^^^^^^^^ Avoid `create` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end

    it "registers an offense for build(:factory)" do
      expect_offense(<<~RUBY)
        it "does something" do
          widget = build(:widget)
                   ^^^^^^^^^^^^^^ Avoid `build` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end

    it "registers an offense for create with traits" do
      expect_offense(<<~RUBY)
        it "does something" do
          user = create(:user, :admin, name: "foo")
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `create` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end
  end

  context "nested inside example block" do
    it "registers offenses for deeply nested calls" do
      expect_offense(<<~RUBY)
        it "does something" do
          result = if condition
            create(:user)
            ^^^^^^^^^^^^^ Avoid `create` inside example blocks. Extract to a `let` or `let!` declaration instead.
          else
            build(:user)
            ^^^^^^^^^^^^ Avoid `build` inside example blocks. Extract to a `let` or `let!` declaration instead.
          end
        end
      RUBY
    end
  end

  context "calls outside example blocks" do
    it "does not register offense for instance_double in let" do
      expect_no_offenses(<<~RUBY)
        let(:dbl) { instance_double(User) }
      RUBY
    end

    it "does not register offense for create in let" do
      expect_no_offenses(<<~RUBY)
        let(:user) { create(:user) }
      RUBY
    end

    it "does not register offense for build in let!" do
      expect_no_offenses(<<~RUBY)
        let!(:widget) { build(:widget) }
      RUBY
    end

    it "does not register offense for instance_double in before block" do
      expect_no_offenses(<<~RUBY)
        before do
          allow(instance_double(User)).to receive(:name)
        end
      RUBY
    end

    it "does not register offense for create in a helper method" do
      expect_no_offenses(<<~RUBY)
        def build_user
          create(:user)
        end
      RUBY
    end

    it "does not register offense for create in context block" do
      expect_no_offenses(<<~RUBY)
        context "something" do
          create(:user)
        end
      RUBY
    end
  end

  context "non-factory create/build calls" do
    it "does not register offense for create without symbol arg" do
      expect_no_offenses(<<~RUBY)
        it "does something" do
          File.create("path")
        end
      RUBY
    end

    it "does not register offense for build without symbol arg" do
      expect_no_offenses(<<~RUBY)
        it "does something" do
          builder.build(config)
        end
      RUBY
    end

    it "does not register offense for create with no args" do
      expect_no_offenses(<<~RUBY)
        it "does something" do
          record.create
        end
      RUBY
    end
  end

  context "multiple offenses in one block" do
    it "registers all offenses" do
      expect_offense(<<~RUBY)
        it "does something" do
          user = create(:user)
                 ^^^^^^^^^^^^^ Avoid `create` inside example blocks. Extract to a `let` or `let!` declaration instead.
          dbl = instance_double(Session)
                ^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `instance_double` inside example blocks. Extract to a `let` or `let!` declaration instead.
          widget = build(:widget)
                   ^^^^^^^^^^^^^^ Avoid `build` inside example blocks. Extract to a `let` or `let!` declaration instead.
        end
      RUBY
    end
  end
end
