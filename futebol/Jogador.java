package futebol;

public class Jogador {

    private String nome;
    private Stats stats;
    private CalculaForcaStrategy calculadoraDeForca;
    private int forca;

    public Jogador(String nome, Stats stats, CalculaForcaStrategy tipoDeForca) {
        this.nome = nome;
        this.forca = -1;
    }
    
    private void atualizaForca() {
        this.forca = this.calculadoraDeForca.calc(this.stats);
    }

    public String getNome() {
        return nome;
    }

    public double getForca() {
        this.atualizaForca();
        return this.forca;
    }

    public String toString() {
        StringBuilder string = new StringBuilder();
        string.append(getNome()).append(" (").append(getForca()).append(")");
        return string.toString();
    }
}