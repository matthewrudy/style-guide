require "spec_helper"

describe StyleGuide::Config do
  describe "#partial_paths" do
    context "when no paths have been added" do
      it { should have_at_least(1).partial_path }
      its(:partial_paths) { should_not include StyleGuide::Engine.root.join("app/views/style_guide/style") }
    end

    context "when adding a path" do
      it "modifies the partial paths" do
        expect do
          subject.partial_paths << "disappointment"
        end.to change{ subject.partial_paths.count }.by(1)
      end
    end

    context "when setting the paths" do
      it "sets the partial paths" do
        expect do
          subject.partial_paths = "loathing"
        end.to change { subject.partial_paths }.to(["loathing"])
      end
    end

    context "after a path has been added" do
      before { subject.partial_paths << "partials-and-magic-beans" }

      its(:partial_paths) { should include "partials-and-magic-beans" }
    end
  end

  describe "#sections" do
    context "when no paths have been added" do
      it { should have_at_least(1).section }
      its(:'sections.first') { should be_a StyleGuide::Section }
    end

    context "when adding a nonexistent path" do
      it "has no impact on the sections" do
        expect do
          subject.paths << "disappointment"
        end.not_to change{ subject.sections.count }
      end
    end

    context "when adding a non-globbed path" do
      let(:path) { StyleGuide::Engine.root.join("app", "views") }

      it "only adds that base path" do
        expect do
          subject.paths << path
        end.to change { subject.sections.count }.by(1)
      end
    end

    context "when adding a globbed path" do
      let(:path) { StyleGuide::Engine.root.join("app", "views", "layouts", "*") }

      it "obeys globbing" do
        expect do
          subject.paths << path
        end.to change { subject.sections.count }.by(1)
      end
    end

    context "when adding existing paths" do
      let(:path) { StyleGuide::Engine.root.join("app", "views", "bootstrap", "**", "*") }

      it "deduplicates existing paths" do
        expect do
          subject.paths << path
        end.not_to change { subject.sections.count }
      end
    end
  end
end
