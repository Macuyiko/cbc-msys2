package solver.wrapper.backend.jnacbc;

import com.sun.jna.IntegerType;
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.PointerType;
import com.sun.jna.ptr.DoubleByReference;
import com.sun.jna.ptr.IntByReference;

public interface JnaCbc extends Library {

	public static final JnaCbc CBC = Native.load(".\\dll\\libCbcSolver-3", JnaCbc.class);

    Cbc_Model Cbc_newModel();

    void Cbc_deleteModel(Cbc_Model model);

    String Cbc_getVersion();

    @Deprecated
    void Cbc_loadProblem(Cbc_Model model, int numcols, int numrows, CoinBigIndex start,
            IntByReference index, DoubleByReference value, DoubleByReference collb, DoubleByReference colub,
            DoubleByReference obj, DoubleByReference rowlb, DoubleByReference rowub);

	void Cbc_loadProblem(Cbc_Model model, int numcols, int numrows, 
			CoinBigIndex start[], int index[], double value[],
			double collb[], double colub[], 
			double obj[], 
			double rowlb[], double rowub[]);
	
	void Cbc_loadProblem(Cbc_Model model, int numcols, int numrows, 
			int start[], int index[], double value[],
			double collb[], double colub[], 
			double obj[], 
			double rowlb[], double rowub[]);
	
    @Deprecated
    int Cbc_readMps(Cbc_Model model, Pointer filename);

    int Cbc_readMps(Cbc_Model model, String filename);

    @Deprecated
    void Cbc_writeMps(Cbc_Model model, Pointer filename);

    void Cbc_writeMps(Cbc_Model model, String filename);

    @Deprecated
    void Cbc_setInitialSolution(Cbc_Model model, DoubleByReference sol);

    void Cbc_setInitialSolution(Cbc_Model model, double sol[]);

    @Deprecated
    void Cbc_problemName(Cbc_Model model, int maxNumberCharacters, Pointer array);

    void Cbc_problemName(Cbc_Model model, int maxNumberCharacters, String array);

    @Deprecated
    int Cbc_setProblemName(Cbc_Model model, Pointer array);

    int Cbc_setProblemName(Cbc_Model model, String array);

    int Cbc_getNumElements(Cbc_Model model);

    int[] Cbc_getVectorStarts(Cbc_Model model);

    IntByReference Cbc_getIndices(Cbc_Model model);

    DoubleByReference Cbc_getElements(Cbc_Model model);

    NativeSize Cbc_maxNameLength(Cbc_Model model);

    @Deprecated
    void Cbc_getRowName(Cbc_Model model, int iRow, Pointer name, NativeSize maxLength);

    void Cbc_getRowName(Cbc_Model model, int iRow, String name, NativeSize maxLength);

    @Deprecated
    void Cbc_getColName(Cbc_Model model, int iColumn, Pointer name, NativeSize maxLength);

    void Cbc_getColName(Cbc_Model model, int iColumn, String name, NativeSize maxLength);

    @Deprecated
    void Cbc_setColName(Cbc_Model model, int iColumn, Pointer name);

    void Cbc_setColName(Cbc_Model model, int iColumn, String name);

    @Deprecated
    void Cbc_setRowName(Cbc_Model model, int iRow, Pointer name);

    void Cbc_setRowName(Cbc_Model model, int iRow, String name);

    int Cbc_getNumRows(Cbc_Model model);

    int Cbc_getNumCols(Cbc_Model model);

    void Cbc_setObjSense(Cbc_Model model, double sense);

    double Cbc_getObjSense(Cbc_Model model);

    DoubleByReference Cbc_getRowLower(Cbc_Model model);

    void Cbc_setRowLower(Cbc_Model model, int index, double value);

    DoubleByReference Cbc_getRowUpper(Cbc_Model model);

    void Cbc_setRowUpper(Cbc_Model model, int index, double value);

    DoubleByReference Cbc_getObjCoefficients(Cbc_Model model);

    void Cbc_setObjCoeff(Cbc_Model model, int index, double value);

    DoubleByReference Cbc_getColLower(Cbc_Model model);

    void Cbc_setColLower(Cbc_Model model, int index, double value);

    DoubleByReference Cbc_getColUpper(Cbc_Model model);

    void Cbc_setColUpper(Cbc_Model model, int index, double value);

    int Cbc_isInteger(Cbc_Model model, int i);

    void Cbc_setContinuous(Cbc_Model model, int iColumn);

    void Cbc_setInteger(Cbc_Model model, int iColumn);

    @Deprecated
    void Cbc_addSOS(Cbc_Model model, int numRows, IntByReference rowStarts, IntByReference colIndices,
            DoubleByReference weights, int type);

    void Cbc_addSOS(Cbc_Model model, int numRows, int rowStarts[], int colIndices[], double weights[],
            int type);

    @Deprecated
    void Cbc_printModel(Cbc_Model model, Pointer argPrefix);

    void Cbc_printModel(Cbc_Model model, String argPrefix);

    Cbc_Model Cbc_clone(Cbc_Model model);

    @Deprecated
    void Cbc_setParameter(Cbc_Model model, Pointer name, Pointer value);

    void Cbc_setParameter(Cbc_Model model, String name, String value);

    void Cbc_registerCallBack(Cbc_Model model, cbc_callback userCallBack);

    void Cbc_clearCallBack(Cbc_Model model);

    int Cbc_solve(Cbc_Model model);

    double Cbc_sumPrimalInfeasibilities(Cbc_Model model);

    int Cbc_numberPrimalInfeasibilities(Cbc_Model model);

    void Cbc_checkSolution(Cbc_Model model);

    int Cbc_getIterationCount(Cbc_Model model);

    int Cbc_isAbandoned(Cbc_Model model);

    int Cbc_isProvenOptimal(Cbc_Model model);

    int Cbc_isProvenInfeasible(Cbc_Model model);

    int Cbc_isContinuousUnbounded(Cbc_Model model);

    int Cbc_isNodeLimitReached(Cbc_Model model);

    int Cbc_isSecondsLimitReached(Cbc_Model model);

    int Cbc_isSolutionLimitReached(Cbc_Model model);

    int Cbc_isInitialSolveAbandoned(Cbc_Model model);

    int Cbc_isInitialSolveProvenOptimal(Cbc_Model model);

    int Cbc_isInitialSolveProvenPrimalInfeasible(Cbc_Model model);

    DoubleByReference Cbc_getRowActivity(Cbc_Model model);

    DoubleByReference Cbc_getColSolution(Cbc_Model model);

    double Cbc_getObjValue(Cbc_Model model);

    double Cbc_getBestPossibleObjValue(Cbc_Model model);

    int Cbc_getNodeCount(Cbc_Model model);

    void Cbc_printSolution(Cbc_Model model);

    int Cbc_status(Cbc_Model model);

    int Cbc_secondaryStatus(Cbc_Model model);

    /** Pointer to unknown (opaque) type */
    public static class CoinBigIndex extends PointerType {
        public CoinBigIndex(Pointer address) {
            super(address);
        }

        public CoinBigIndex() {
            super();
        }
    };

    /** Pointer to unknown (opaque) type */
    public static class cbc_callback extends PointerType {
        public cbc_callback(Pointer address) {
            super(address);
        }

        public cbc_callback() {
            super();
        }
    };

    /** Pointer to unknown (opaque) type */
    public static class Cbc_Model extends PointerType {
        public Cbc_Model(Pointer address) {
            super(address);
        }

        public Cbc_Model() {
            super();
        }
    };

    public class NativeSize extends IntegerType {
        private static final long serialVersionUID = 2398288011955445078L;
        public static int SIZE = Native.SIZE_T_SIZE;

        public NativeSize() {
            this(0);
        }

        public NativeSize(long value) {
            super(SIZE, value);
        }
    }

}
