require 'spec_helper'

describe 'MailExtract::Line' do
  def line(str)
    MailExtract::Line.new(str)
  end
  
  it 'detects quote start by date' do
    line('On Tue, 2011-03-01 at 18:02 +0530, somebody wrote:').type.should == :quote
    line('On Tue, 2011-03-01 at 18:02 +0530, somebody wrote:').subtype.should == :start
    line('On 2011-03-01 at 18:02 somebody wrote').type.should == :quote
    line('On 2011-03-01 at 18:02 somebody wrote').subtype.should == :start
    line('From: dfas34_$@asd.info').type.should == :quote
    line('From: dfas34_$@asd.info').subtype.should == :start
    line('Date: Wed, 16 Oct 2013 18:01:12 +0000').type.should == :quote
    line('Date: Wed, 16 Oct 2013 18:01:12 +0000').subtype.should == :start
    line('On some day somebody wrote').type.should == :text
  end
  
  it 'detects quote' do
    line('> this is a quote').type.should == :quote
    line('> this is a quote').subtype.should == :none
    line('> >> this is a quote').type.should == :quote
  end
  
  it 'detects signature' do
    lines = [
     "--\nUsername",
     "-- \nUsername",
     "_______\nSome text",
     "Sent from my iPhone",
     "Sent from my iPad"
    ]
    
    lines.each do |l|
      line(l).type.should == :signature
    end
  end

  it 'detects reply above lines' do
    line('>Please reply above this line ^^').type.should == :reply_above
  end
end
