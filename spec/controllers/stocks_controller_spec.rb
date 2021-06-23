require 'rails_helper'

describe StocksController, type: :controller do
  describe '.index' do
    context 'without param' do
      it 'should render without data' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'with search param' do
      context 'fail to fetch data' do
        before { allow(StockyService).to receive(:get_daily_series).with('AAPL').and_return(nil) }

        it 'should render with data' do
          get :index, params: {search: 'AAPL'}

          expect(response).to render_template('index')
          expect(flash[:error]).to be_present
        end
      end

      context 'success on fetch data' do
        before { allow(StockyService).to receive(:get_daily_series).with('AAPL').and_return(['something']) }

        it 'should render with data' do
          get :index, params: {search: 'AAPL'}

          expect(response).to render_template('index')
          expect(flash[:error]).not_to be_present
        end
      end
    end
  end
end
