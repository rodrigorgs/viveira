Feature: Adicionar pessoa

  Background:
    Given o app está rodando

  Scenario: (eqE) Adicionar Pessoa com nome inválido 
    When eu adiciono uma pessoa com
      | 'Nome completo' | 'CPF' |
      | 'abcde0'        | '123' |
    Then eu vejo o texto {'Nome inválido'}

  Scenario: (eqE) Adicionar Pessoa com CPF inválido 
    When eu adiciono uma pessoa com
      | 'CPF'          |
      | '1234567890'  |
    Then eu vejo o texto {'CPF inválido'}

  Scenario: Adicionar Pessoa com CPF válido 
    When eu adiciono uma pessoa com
      | 'CPF'         |
      | '64218723010' |
    Then eu não vejo o texto {'CPF inválido'}