package futebol;

public class Jogador {

    private String nome;
    private Stats stats;
    private ForcaCalculator calculadoraDeForca;
    private int forca;

    public Jogador(String nome, Stats stats, ForcaCalculator tipoDeForca) {
        this.nome = nome;
        this.stats = stats;
        this.calculadoraDeForca = tipoDeForca;
        this.getForca();
    }
    
    public String getNome() {
        return nome;
    }

    public int getForca() {
        this.forca = this.calculadoraDeForca.calc(this.stats);
        return this.forca;
    }

    public String toString() {
        StringBuilder string = new StringBuilder();
        string.append(getNome()).append(" (").append(getForca()).append(")");
        return string.toString();
    }
}
