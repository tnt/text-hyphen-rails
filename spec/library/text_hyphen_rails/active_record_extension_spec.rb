require 'rails_helper'

RSpec.describe TextHyphenRails::ActiveRecordExtension do
  before(:all) do
    @orig_text = 'A blasphemical <blockquote>shortnovela</blockquote> with enormouslargely fantasywords.'
    @uk_hyph = 'A blas-phem-ic-al <block-quote>short-nov-ela</block-quote> with enorm-ouslargely fantasy-words.'
    @us_hyph = 'A blas-phem-i-cal <block-quote>short-nov-ela</block-quote> with enor-mous-large-ly fan-ta-sy-words.'
    @de_hyph = 'Ein blas-phe-mi-scher Kurz-ro-man mit rie-sen-lan-gen Fan-ta-sie-wör-tern.'
    @uk_html = 'A blas-phem-ic-al <blockquote>short-nov-ela</blockquote> with enorm-ouslargely fantasy-words.'
  end

  describe '.text_hyphen' do
    context 'when used without any options' do
      subject() { build(:post, :var1) }
      before(:example) do
        class Post < ActiveRecord::Base
          text_hyphen :text
        end
      end
      after(:each) do
        Object.send(:remove_const, :Post)
      end

      it 'creates a method with suffix "_hyph"' do
        expect(subject.respond_to? :text_hyph).to be true
      end

      it 'the created method returns a hyphenated string' do
        expect(subject.text_hyph).to eq(@uk_hyph)
      end
    end

    context 'when used with the :replace_meth option' do
      subject() { build(:post, :var2) }
      before(:example) do
        class Post < ActiveRecord::Base
          text_hyphen :text, replace_meth: true
        end
      end
      after(:each) do
        Object.send(:remove_const, :Post)
      end

      it 'creates a method with no suffix' do
        expect(subject.respond_to? :text).to be true
      end

      it 'the created method returns a hyphenated string' do
        expect(subject.text).to eq(@uk_hyph)
      end

      it 'creates a method with "_orig" suffix' do
        expect(subject.respond_to? :text_orig).to be true
      end

      it 'the created method with "_orig" suffix returns the unmodified string' do
        expect(subject.text_orig).to eq(@orig_text)
      end
    end

    context 'when used with the :lang_att option' do
      subject() { build(:post, :var3) }
      let(:american) { build(:post, :american) }
      let(:german) { build(:post, :german) }
      before(:example) do
        class Post < ActiveRecord::Base
          text_hyphen :text, lang_att: :lang
        end
      end
      after(:each) do
        Object.send(:remove_const, :Post)
      end

      it 'the created method returns a string hyphenated according the configured language attribute' do
        expect(subject.text_hyph).to eq(@uk_hyph)
        expect(american.text_hyph).to eq(@us_hyph)
        expect(german.text_hyph).to eq(@de_hyph)
      end
    end
  end

  describe '.html_hyphen' do
    context 'when used without any options' do
      subject() { build(:post, :var4) }
      before(:example) do
        class Post < ActiveRecord::Base
          html_hyphen :text
        end
      end
      after(:each) do
        Object.send(:remove_const, :Post)
      end

      it 'creates a method with suffix "_hyph"' do
        expect(subject.respond_to? :text_hyph).to be true
      end

      it 'the created method returns a hyphenated string' do
        expect(subject.text_hyph).to eq(@uk_html)
      end
    end
  end
end