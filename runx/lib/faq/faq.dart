// System Packages
import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ - Perguntas e Respostas')),
      body: buildList(context),
    );
  }

  Widget buildList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: faqs.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildExpandableTile(faqs[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildExpandableTile(item) {
    return ExpansionTile(
      title: Text(item['author'],
          style: const TextStyle(fontWeight: FontWeight.bold)),
      children: <Widget>[
        ListTile(
          tileColor: const Color.fromARGB(255, 238, 244, 246),
          title: Text(
            item['quote'],
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}

final List faqs = [
  {
    "quote":
        "Runx foi desenvolvida como componente mobile do projeto da cadeira PECI, do curso LECI, na Universidade de Aveiro."
            "\nO grupo responsável por este projeto foi o grupo 04, constituido por: "
            "\n-António Ferreira 89082"
            "\n-Diogo Maduro 80233"
            "\n-Filipe Pires 80063"
            "\n-Francisco Teixeira 84843"
            "\n-Luís Couto 89078",
    "author": "Quem Somos?"
  },
  {
    "quote": "Ao possuir uma conta grátis, poderá:"
        "\n-Ter acesso a uma biblioteca de exercicios e planos de treino grátis"
        "\n-Realizar treinos e manter um historial destes"
        "\n-Dar tracking à evolução dos seus dados fisicos",
    "author": "Conta Grátis"
  },
  {
    "quote":
        "Para além de todas as funcionalidades de uma conta grátis, poderá ainda:"
            "\n-Associar-se e interagir com um instrutor"
            "\n-Receber planos de treino personalizados"
            "\n-Associar dispositivos moveis de fitness"
            "\n-Avaliar o seu instrutor",
    "author": "Conta Premium"
  },
  {
    "quote":
        "Se deseja ter uma conta premium, pode proceder ao pagamento desta através do gateway disponibilizado, neste caso Paypal.",
    "author": "Como ter uma conta premium?"
  },
  {
    "quote":
        "Para interagir com um instrutor, tem de primeiro se associar a um, podendo escolher qualquer que tenha vagas disponiveis."
            "\nApós isso, poderá comunicar com este através do chat disponibilizado, para esclarecer qualquer dúvida ou pedir planos personalizados.",
    "author": "Como posso interagir com instrutores?"
  },
  {
    "quote":
        "É possivel trocar de instrutor passado mais de 7 dias desde a data da respetiva associação",
    "author": "Posso trocar o meu instrutor?"
  },
  {
    "quote":
        "Na página de login existe um link que o levará para a página de recuperação."
            "\nNesta, introduza o email da sua conta e confirme, devendo depois receber na sua caixa de correio um email com link para a alteração da password.",
    "author": "Perdi/Quero alterar a password"
  },
  {
    "quote":
        "Se eventualmente se deparar com um erro, siga os passos seguintes até este estar resolvido:"
            "\n1-Verifique a sua conexão á internet"
            "\n2-Volte atrás da página onde dá erro e volte a abrir"
            "\n3-Encerre e volte a iniciar a aplicação"
            "\n4-Saia e volte a entrar na sua conta"
            "\n5-Contacte o apoio técnico",
    "author": "Ocorreu um erro?"
  },
];
