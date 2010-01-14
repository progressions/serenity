require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do
  before(:each) do
    $stdout.stub!(:puts)
    @options = {
      "ship" => {
        "name" => "Serenity",
        "class" => "Firefly",
        "crew" => {
          "captain" => "Mal Reynolds"
        }
      }
    }
    @filename = "#config.yml"
    YAML.stub!(:load_file).with(@filename).and_return(@options)
  end
  
  describe "initialization" do
    it "should make a new object" do
      Serenity::Configuration.new(@filename).should_not be_nil
    end
    
    it "should raise an error if file doesn't exist" do
      YAML.stub!(:load_file).and_raise(Errno::ENOENT)
      lambda {
        Serenity::Configuration.new("config_doesnt_exist.yml")
      }.should raise_error
    end
    
    it "should raise an error if filename is blank" do
      lambda {
        Serenity::Configuration.new("")
      }.should raise_error
    end
    
    it "should raise an error if filename is nil" do
      lambda {
        Serenity::Configuration.new
      }.should raise_error
    end
    
    describe "accessors" do
      before(:each) do 
        @config = Serenity::Configuration.new(@filename)
      end
      
      it "should set filename" do
        @config.filename.should == @filename
      end
      
      it "should return options" do
        @config.to_hash.should == @options
      end
    end
  end
  
  describe "get" do
    before(:each) do 
      @config = Serenity::Configuration.new(@filename)
    end
    
    it "should return hash of complex values" do
      @config.get("ship").should == @options["ship"]
    end
    
    it "should go down several levels" do
      @config.get("ship", "crew", "captain").should == @options["ship"]["crew"]["captain"]
    end
    
    it "should return error if option doesn't exist" do
      $stdout.should_receive(:puts).with("The following option was not found in #{@filename}:")
      lambda {
        @config.get("ship", "albatross")
      }.should raise_error
    end
  end
end










