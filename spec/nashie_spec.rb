require 'spec_helper'

describe Hashie::Nash do

  class Test1 < Hashie::Nash
    property :meh,:required => true
  end

  class NestedTest < Hashie::Nash
    property :nest, :class => Test1
  end

  class NestedWithStringTest < Hashie::Nash
    property :nest, :class => "Test1"
  end

  class Phrase < Hashie::Nash
    property :phrase, :required => true
  end

  class NestedList < Hashie::Nash
    property :nests, :class => "Phrase", :collection => true
  end

  it "should create a new Test1" do
     t = Test1.new "meh"=> 5
     t.nil?.should == false
  end

  it "should create a new NestedTest" do
     t = NestedTest.new "nest" => {"meh"=> 5}
     t.nil?.should == false
  end

  it "should make nested hashes accessible" do
    t = NestedTest.new "nest" => {"meh"=> 5}
    t.nest.meh.should == 5
  end

  it "should make nested hashes with strings accessible" do
    t = NestedWithStringTest.new "nest" => {"meh"=> 5}
    t.nest.meh.should == 5
  end

  it "should deal with collections of items properly" do
    t = NestedList.new "nests" => [{"phrase" => "phrase 1"}, {"phrase" => "phrase 2"}]
    t.nests.count.should == 2
    t.nests.first.phrase.should == "phrase 1"
  end

  it "should make validate required properties in nested dash" do
    lambda do
    t = NestedTest.new "nest" => {"non_existent"=> 5}
    t.nest.meh.should == 5
    end.should raise_error NoMethodError
  end

  class Part < Hashie::Nash
     property :name, :required => true
  end

  class Engine < Hashie::Nash
    property :build_year, :required => true
    property :nitro, :default => false
    property :parts, :collection => true, :class => "Part"
  end

  class Car < Hashie::Nash
    property :engine, :required => true, :class => Engine
  end


  it "should make validate required properties in nested dash" do
    car = Car.new "engine" => {"build_year" => 2010, "nitro" => false, :parts => [{"name" => "crankshaft"}, {"name" => "flywheel"}]}
    car.engine.build_year.should == 2010
    car.engine.nitro.should be_false
    car.engine.parts.count.should == 2
    car.engine.parts.first.name.should == "crankshaft"
  end

  class Presentation < Hashie::Nash
    property :users, :collection => true, :required => true do
       property :name
    end
  end
  require "pry"
  it "should accept blocks" do
    p = Presentation.new :users => [{"name"=> "Bob"}, {"name"=>"Eve"}]
    p.users.count.should == 2
    p.users.first.name.should == "Bob"
  end
end
