# require 'spec_helper'

describe App do
  def app
    App
  end

  let(:fill_params) do
    {
      caixa: 
        {
          caixaDisponivel: true,
          notas:
            {
              notasDez: 10,
              notasVinte: 30,
              notasCinquenta: 20,
              notasCem: 15
            } 
        }
      }
  end


  describe 'ping' do
    it 'returns pong' do
      get '/ping'

      expect(last_response.body).to eq 'PONG'
      expect(last_response.status).to eq 200
    end
  end

  describe 'fill' do
    context 'with success' do
      let(:expected_response) do
        {
          "caixa" => {
            "caixaDisponivel" => true,
            "notas" => {
              "notasDez" => 10,
              "notasVinte" => 30,
              "notasCinquenta" => 20,
              "notasCem" => 15
            }
          },
          "erros" => []
        }
      end

      it do
        post '/fill', fill_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end

    context 'with error' do
      let(:expected_response) do
        {
          "caixa" => 
            {
              "caixaDisponivel" => true,
              "notas" => 
                {
                  "notasDez" => 10,
                  "notasVinte" => 30,
                  "notasCinquenta" => 20,
                  "notasCem" => 15
                }
            },
          "erros" => ['caixa-em-uso']
        }
      end

      before { post '/fill', fill_params.to_json, 'CONTENT_TYPE' => 'application/json' }

      it do
        post '/fill', fill_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'withdraw' do
    let(:withdraw_params) do
      {
        saque:
          {
            valor: 80,
            horario:"2019-02-13T11:01:01.000Z"
          }
      }
    end

    context 'with success' do
      let(:expected_response) do
        {
          "caixa" => 
            {
              "caixaDisponivel" => true,
              "notas" => 
              {
                "notasDez" => 9,
                "notasVinte" => 29,
                "notasCinquenta" => 19,
                "notasCem" => 15
              } 
            },
          "erros" => []
        }
      end

      before { post '/fill', fill_params.to_json, 'CONTENT_TYPE' => 'application/json' }

      it do
        post '/withdraw', withdraw_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end

    context 'with error - unavailable' do
      let(:expected_response) do
        {
          "caixa" => 
            {
              "caixaDisponivel" => false,
              "notas" => 
              {
                "notasDez" => 9,
                "notasVinte" => 29,
                "notasCinquenta" => 19,
                "notasCem" => 15
              } 
            },
          "erros" => ['caixa-indisponível']
        }
      end

      before do
        ATM.available = false
      end

      it do
        post '/withdraw', withdraw_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end

    context 'with error - duplicated' do
      let(:expected_response) do
        {
          "caixa" => 
            {
              "caixaDisponivel" => true,
              "notas" => 
              {
                "notasDez" => 9,
                "notasVinte" => 29,
                "notasCinquenta" => 19,
                "notasCem" => 15
              } 
            },
          "erros" => ['saque-duplicado']
        }
      end

      before do
        ATM.available = true
        post '/withdraw', withdraw_params.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      it do
        post '/withdraw', withdraw_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end

    context 'with error - insufficient balance' do
      let(:expected_response) do
        {
          "caixa" => 
            {
              "caixaDisponivel" => true,
              "notas" => 
              {
                "notasDez" => 9,
                "notasVinte" => 29,
                "notasCinquenta" => 19,
                "notasCem" => 15
              } 
            },
          "erros" => ['valor-indisponível']
        }
      end

      before do
        withdraw_params[:saque][:valor] = 10000
      end

      it do
        post '/withdraw', withdraw_params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(JSON.parse(last_response.body)).to eq expected_response
        expect(last_response.status).to eq 200
      end
    end
  end
end

