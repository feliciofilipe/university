import org.junit.Test;

import nz.ac.waikato.modeljunit.GreedyTester;
import nz.ac.waikato.modeljunit.RandomTester;
import nz.ac.waikato.modeljunit.Tester;
import nz.ac.waikato.modeljunit.VerboseListener;
import nz.ac.waikato.modeljunit.coverage.ActionCoverage;
import nz.ac.waikato.modeljunit.coverage.StateCoverage;
import nz.ac.waikato.modeljunit.coverage.TransitionCoverage;
import nz.ac.waikato.modeljunit.coverage.TransitionPairCoverage;
public class TheftAlarmTester {

    @Test
    public void randomTester() throws Exception {
        System.out.println("______________Random______________");
        TheftAlarmModel theft = new TheftAlarmModel();
        Tester tester = new RandomTester(theft);
        tester.buildGraph();
        tester.buildGraph().printGraphDot("randomModel.dot");
        printOutput(tester);

    }

    @Test
    public void greedyTester() throws Exception {
        System.out.println("______________Greedy______________");
        TheftAlarmModel theft = new TheftAlarmModel();
        Tester tester = new GreedyTester(theft);
        tester.buildGraph();
        tester.buildGraph().printGraphDot("greedyModel.dot");
        printOutput(tester);
    }

    private void printOutput(Tester tester) {
        System.out.println(tester.buildGraph().getGraph());
        tester.addListener(new VerboseListener());
        tester.addCoverageMetric(new ActionCoverage());
        tester.addCoverageMetric(new StateCoverage());
        tester.addCoverageMetric(new TransitionCoverage());
        tester.addCoverageMetric(new TransitionPairCoverage());
        System.out.println("\n______________Generate tests______________");
        tester.generate(13);
        System.out.println("\n______________Coverage report______________");
        tester.printCoverage();
    }
}
