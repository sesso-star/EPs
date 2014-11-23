package futebol;
import java.io.*;

import java.util.ArrayList;

class Leitor {
    public static ArrayList<Jogador> leJogadores() {
        ArrayList<Jogador> jogadores = new ArrayList<Jogador>();
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            String input;
            while ((input = br.readLine()) != null) {
                int i = input.indexOf('#');
                if (i != -1) {
                    input = input.substring(0, i);
                }
                input = input.replaceAll("\\s", "");
                String[] statList = input.split(",");
                if (statList.length == 8) {
                    String nome = statList[0];
                    int idade = Integer.parseInt(statList[1]);
                    double altura = Double.parseDouble(statList[2]);
                    double peso = Double.parseDouble(statList[3]);
                    int forca = Integer.parseInt(statList[4]);
                    int velocidade = Integer.parseInt(statList[5]);
                    int explosao = Integer.parseInt(statList[6]);
                    int resistencia = Integer.parseInt(statList[7]);
                    Stats stats = new Stats(idade, altura, peso, velocidade, explosao, resistencia);
                    FutebolStrategy tipodejogo = new FutebolStrategy();
                    jogadores.add(new Jogador(nome, stats, tipodejogo));
                }
            }
        }
        catch(IOException io) {
            io.printStackTrace();
        }
        return jogadores;   
    }

    public static void main(String[] args) {
        // Short method for testing this class
        ArrayList<Jogador> jogadores = leJogadores();
        for (Jogador j : jogadores) {
            System.out.println(j.getNome());
        }
    }   
}