require 'spec_helper'


describe KDTree do

  let(:nodes) { [[1,2,3], [4,5,6]] }
  let(:dims) { 3 }

  subject { described_class.new(nodes, dims) }

  describe ".new" do
    subject { described_class }

    context "with valid arguments" do
      it "returns an instance of KDTree" do
        subject.new(nodes, dims).should be_a(KDTree)
      end
    end

    context "with no nodes" do
      let(:nodes) { nil }
      it "raises an error" do
        expect { subject.new(nodes, dims) }.to raise_error
      end
    end

    context "with no dimensions" do
      let(:dims) { nil }
      it "raises an error" do
        expect { subject.new(nodes, dims) }.to raise_error
      end
    end

    context "with non-array nodes" do
      let(:nodes) { {} }
      it "raises an error" do
        expect { subject.new(nodes, dims) }.to raise_error
      end
    end

    context "with non-integer dimensions" do
      let(:dims) { '3' }
      it "raises an error" do
        expect { subject.new(nodes, dims) }.to raise_error
      end
    end

    context "with invalid dimensions" do
      let(:dims) { 2 }
      it "raises an error" do
        expect { subject.new(nodes, dims) }.to raise_error
      end
    end

  end

  describe "#insert" do

    let(:node) { [6,7,8] }

    it "returns the inserted node" do
      subject.insert(node).should == node
    end

    it "inserts the node into the tree" do
      subject.insert(node)
      res = subject.nearest_neighbor(node)
      res.fetch("query").should == node
      res.fetch("position").should == node
      res.fetch("distance").should == 0.0
    end

  end

  describe "#nearest_neighbor" do
    let(:query) { nodes.first }

    let(:response) { subject.nearest_neighbor(query) }

    it "returns a hash" do
      response.should be_a(Hash)
    end

    it "returns the query" do
      response.fetch("query").should == query
    end

    it "returns the matched node" do
      response.fetch("position").should == query
    end

    it "returns the distance" do
      response.fetch("distance").should == 0.0
    end

    context "distance" do

      # Query Node: [ 101, 102, 103 ]
      # Expected Node: [ 4, 5, 6 ]
      # Calculation: (101 - 4)^2 + (102 - 5)^2 + (103 - 6)^2 = 28227.0

      let(:query) { nodes.first.map {|i| i + 100 } }

      it "calculates correctly" do
        response.fetch("distance").should == 28227.0
      end

    end
  end

end
