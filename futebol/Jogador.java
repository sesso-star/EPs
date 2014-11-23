package futebol;

public class Jogador {

    private String nome;
    private Stats stats;
    private double pontuacao;
    private Forca forca;

    public Jogador(String nome, Stats stats, CalculaForcaStrategy tipoDeForca) {
        this.nome = nome;
        this.pontuacao = pontuacao;
        this.forca = new Forca(tipoDeForca);
    }
    
    private atualizaPontuacao() {
        this.potuacao = this.forca.calcForca(this.stats);
    }

    public String getNome() {
        return nome;
    }

    public double getForca() {
        this.atualizaPontuacao();
        return pontuacao;
    }
    
    public String toString() {
        StringBuilder string = new StringBuilder();
        string.append(getNome()).append(" (").append(getForca()).append(")");
        return string.toString();
    }
}